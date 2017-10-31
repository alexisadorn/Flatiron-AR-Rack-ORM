class AddShowsToNetwork < ActiveRecord::Migration
  #to make an additive change to a schema we create
  #a new migration, and then in the change method,
  #we make the change.
  def change
    add_column :shows, :network_id, :integer
  end
end
