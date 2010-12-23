class AddCultureToHottrend < ActiveRecord::Migration
  def self.up
    add_column :hottrends, :culture, :string
  end

  def self.down
    remove_column :hottrends, :culture
  end
end
