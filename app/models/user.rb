class User < ActiveRecord::Base
  before_create :set_default_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  private
  def set_default_role
    self.role ||= 'member'
  end
end
