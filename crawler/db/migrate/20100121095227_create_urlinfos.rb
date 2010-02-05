class CreateUrlinfos < ActiveRecord::Migration
  def self.up
    create_table :urlinfos do |t|
      t.string :url
      t.text :title
      t.text :description
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :urlinfos
  end
end
