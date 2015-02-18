class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.references :user
      t.string :name
      t.timestamps
    end
  end
end
