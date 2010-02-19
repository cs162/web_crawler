class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :urls do |t|
      t.integer :id
      t.string :url_name
      t.text :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :urls
  end
end
