class WikisController < ApplicationController
  before_action :require_login, except: [:index, :show]

  def index
    @wikis = Wiki.all
  end

  def my_wikis
    @wikis = Wiki.where(user_id: current_user.id)
    if @wikis == nil then
      @wikis = []
    end
  end

  def show
    @wiki = Wiki.joins(:user).find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]
    @wiki.user_id = current_user.id

    if @wiki.save!
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error, please try again"
      render :new
    end
  end

  def edit
    @wiki = Wiki.joins(:user).find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    @wiki.title = params[:wiki][:title]
    @wiki.body = params[:wiki][:body]

    if @wiki.save!
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else
      flash.now[:alert] = "There was an error, please try again"
      render :new
    end
  end

  def destroy
    @wiki = Wiki.find(params[:id])
    if @wiki.destroy then
      flash[:notice] = "Wiki was deleted sucessfully."
    else
      flash[:alert] = "Error deleting wiki."
    end
    redirect_to :my_wikis
  end
end
