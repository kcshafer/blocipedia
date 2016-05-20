module ApplicationHelper
    def can_upgrade
        return current_user && !current_user.premium
    end
end
