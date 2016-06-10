module ApplicationHelper
    def can_upgrade
        return current_user && current_user.role != 'premium'
    end

    def to_markdown(t)
        # renderer = Redcarpet::Render::HTML.new
        # rc = Redcarpet::Markdown.new(renderer)
        rc = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
        rc.render(t).html_safe
    end
end
