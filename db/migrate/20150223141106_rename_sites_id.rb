class RenameSitesId < ActiveRecord::Migration
  def change
    rename_column :sites, :user_id, :uid
  end
end
