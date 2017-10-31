class AddDayAndSeasonToShows < ActiveRecord::Migration
  def change
    add_column :shows, :day, :string
    add_column :shows, :season, :string
  end
end
