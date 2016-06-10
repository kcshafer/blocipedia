class CollaboratorsController < ApplicationController
    before_action :require_login
    before_action :set_wiki
    
    def index
      logger.info "INDEX"
      logger.info params
      @wiki_id = params[:wiki_id]
      @collaborators = User.joins('left join collaborators on users.id = collaborators.user_id where collaborators.wiki_id is null or collaborators.wiki_id = ' + params[:wiki_id]).select('users.email, collaborators.id, users.id as user_id, collaborators.wiki_id').order(:email)
    end

    def create
      logger.info "CREATE"
      logger.info params

      c = @wiki.collaborators.new(user_id: params[:user][:user_id])
      
      if c.save! then
        flash[:notice] = "Collaborator added successfully!"
      else
        flash[:alert] = "Unable to add collaborator :("
      end

      redirect_to wiki_collaborators_path(@wiki)
    end

    def destroy
      logger.info "DESTROY"
      logger.info params

      collab = Collaborator.find(params[:user][:collab_id])

      if collab.destroy! then
        flash[:notice] = "Collaborator removed successfully!"
      else 
        flash[:notice] = "Unable to remove collaborator :("
      end

      redirect_to wiki_collaborators_path(@wiki)
    end 

    private

    def set_wiki
      @wiki = Wiki.find(params[:wiki_id])
    end
end