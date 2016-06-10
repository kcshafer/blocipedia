class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :collaborators, :dependent => :delete_all
  #TODO: this needs to be able to access current_user to work
  #scope :owned_by, -> { where(user_id: 1)}
end
