class CreateUrlSearches < ActiveRecord::Migration
  def self.up
    create_table :url_searches do |t|
      t.integer :id
      t.text :url_name
      t.text :title
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :url_searches
  end
end
