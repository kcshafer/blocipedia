class User < ActiveRecord::Base
  before_create :set_defaults
  after_update :complete_downgrade

  has_many :wikis, :dependent => :delete_all
  has_many :collaborators, :dependent => :delete_all

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  enum role: [:member, :premium, :admin]

  private
  def set_defaults
    self.role ||= :member
  end

  def complete_downgrade
    if self.role_changed? && self.role != 'premium' then
        wikis = Wiki.where(user_id: self.id)
        wikis.each do |w|
            w.private = false
            w.save!
        end
    end
  end
end
