module WikisHelper
    def can_edit(wiki)
        return current_user
    end

    def can_delete(wiki)
        return current_user && current_user.role = 'admin'
    end
end
