class CreateHottrends < ActiveRecord::Migration
  def self.up
    create_table :hottrends do |t|
      t.date :date
      t.integer :num
      t.string :text

      t.timestamps
    end
  end

  def self.down
    drop_table :hottrends
  end
end
