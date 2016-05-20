class User < ActiveRecord::Base
  before_create :set_defaults

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  private
  def set_defaults
    self.role ||= 'member'
  end
end
