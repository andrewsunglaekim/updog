class Site < ActiveRecord::Base
  belongs_to :user
  after_create :create_db_folder

  private
  def create_db_folder

  end
end
