class User < ActiveRecord::Base
  before_create :set_defaults
  after_update :complete_downgrade

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  private
  def set_defaults
    self.role ||= 'member'
  end

  def complete_downgrade
    if self.premium_changed? && !self.premium then
        wikis = Wiki.where(user_id: self.id)
        wikis.each do |w|
            w.private = false
            w.save!
        end
    end
  end
end
