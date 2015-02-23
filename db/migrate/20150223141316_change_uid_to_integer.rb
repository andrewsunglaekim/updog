class ChangeUidToInteger < ActiveRecord::Migration
  def change
    connection.execute(%q{
      alter table users
      alter column uid
      type integer using cast(uid as integer)
    })
  end
end
