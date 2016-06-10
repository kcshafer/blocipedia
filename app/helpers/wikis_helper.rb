module WikisHelper
  def can_edit(wiki)
    collaborator_ids = [] 
    # wiki_collaborators = Wiki.select('collaborators.user_id').where(id: wiki.id).joins(:collaborators)
    wiki.collaborators.each do |wc|
       collaborator_ids.push(wc.user_id) 
    end

    logger.info "collab ids"
    logger.info collaborator_ids

    return (current_user.id == wiki.user_id || current_user.role == 'admin' || collaborator_ids.include?(current_user.id))
  end

  def can_delete(wiki)
    return current_user && current_user.role = 'admin'
  end
end
