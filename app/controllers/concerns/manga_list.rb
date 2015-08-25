module MangaList
  extend ActiveSupport::Concern
  require 'open-uri'

  def chapter_list
    title = Nokogiri::HTML(open(@title.url))
    volumes = title.css("#chapters .slide h3")
    chapters = title.css(".chlist")

    list = []

    volumes.each_with_index do |v, i|
      list << {
        volume: v.text,
        chapters: chapters[i].css("li").map{ |c| { url: c.css('.tips')[0][:href], title: "#{ c.css('.tips').text } - #{ c.css('.title').text }" } }
      }
    end

    list
  end
end
