class RenameDomainToSubdomain < ActiveRecord::Migration
  def change
    rename_column :sites, :domain, :subdomain
  end
end
