class Downloader
  require 'open-uri'
  require 'fileutils'
  require 'zip'
  include Sidekiq::Worker

  def perform(c_title, c_url)
    chapter = Nokogiri::HTML(open(c_url))
    last_page = chapter.css('#top_bar .l select option').map{|o| o[:value].to_i }.sort.last
    a_chapter = c_url.split('/')
    a_count = a_chapter.count
    path_name = Pathname.new("#{ Rails.root }/public/mangas")
    ch_title = c_title.downcase.gsub(" ", "_")
    folder_name = path_name.join(ch_title)
    archive_name = path_name.join("#{ ch_title }.cbr")

    dirname = File.dirname(folder_name)
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    FileUtils.mkdir_p(folder_name) unless File.directory?(folder_name)


    image_names = []
    ctr = 1
    while ctr <= last_page do
      page_endpoint = (/html/ =~ a_chapter.last).nil? ? 1 : 2
      url = "#{ a_chapter[0] }//#{ a_chapter[2..(a_count - page_endpoint)].join('/') }/#{ ctr }.html"
      page = Nokogiri::HTML(open(url))
      image_url = page.css('#viewer img').first[:src]
      image_name = image_url.split('/').last
      image_path = folder_name.join(image_name)

      image_names << image_name

      File.open(image_path, 'wb') do |fo|
        fo.write open(image_url).read
      end

      ctr += 1
    end

    Zip::File.open(archive_name, Zip::File::CREATE) do |zf|
      image_names.each do |f|
        zf.add(f, "#{ folder_name }/#{ f }")
      end
    end

    FileUtils.rm_rf(folder_name)
  end
end
