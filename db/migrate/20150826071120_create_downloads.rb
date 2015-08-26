class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :url
      t.string :title
      t.references :user, index: true

      t.timestamps null: false
    end

    add_foreign_key :downloads, :users
  end
end
