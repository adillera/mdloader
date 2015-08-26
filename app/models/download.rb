class Download < ActiveRecord::Base
  require 'fileutils'

  belongs_to :user

  before_destroy :remove_downloaded_data

  private
  def remove_downloaded_data
    FileUtils.rm_rf(self.url)
  end
end
