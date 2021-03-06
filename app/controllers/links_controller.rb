class LinksController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :authorized_user, only: [:edit, :update, :destroy]


  # GET /links
  # GET /links.json
  def index
    @links = Link.paginate(:page => params[:page], :per_page => 10).order(created_at: :desc)
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = current_user.links.build
  end

  # GET /links/1/edit
  def edit
    if @link.nil?
      @link = Link.find(params[:id])
    end
  end

  # POST /links
  # POST /links.json
  def create
    @link = current_user.links.build(link_params)

    respond_to do |format|
      if @link.save
        format.html { redirect_to @link, notice: 'Link was successfully created.' }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    if @link.nil?
      @link = Link.find(params[:id])
    end
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    if @link.nil?
      @link = Link.find(params[:id])
    end
    #@comments = Comment.find_by_link_id(params[:id])
    #@comments.each do |comment|
    #  comment.destroy
    #end
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @link = Link.find(params[:id])
    @link.upvote_by current_user
    redirect_to :back
  end

  def downvote
    @link = Link.find(params[:id])
    @link.downvote_by current_user
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:title, :url)
    end

    def authorized_user
      @link = current_user.links.find_by(id: params[:id])
      #redirect_to links_path, notice: "Not authorized to edit this link" if @link.nil? || current_user.try(:admin?)
      redirect_to :links_path unless user_signed_in? || current_user.admin?
    end
end
