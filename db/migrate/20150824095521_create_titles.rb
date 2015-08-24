class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :name
      t.string :url
      t.references :user

      t.timestamps null: false
    end
  end
end
