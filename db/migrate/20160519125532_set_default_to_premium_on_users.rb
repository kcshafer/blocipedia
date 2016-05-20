class SetDefaultToPremiumOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :premium, :boolean, :default => false
  end
end
