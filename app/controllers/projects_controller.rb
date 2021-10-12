class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show, :add_to_cart, :remove_from_cart]

  # GET /projects or /projects.json
  def index
    # @projects = Project.all
    @projects = Project.page params[:page]
    # @query = params[:q] ||= ""
    # @projects = Project.where("title LIKE?", "%#{@query}%").page params[:page]

    respond_to do |format|
      format.html
      # format.json  { render :json => @projects }
      # format.js { render 'index.js.erb' }
      format.js
    end
  end

  def search
    # if params[:q].blank?
    #   @projects = Project.page params[:page]
    # else
    #   @query = params[:q]
    #   # @projects = Project.search(params[:q]).page params[:page]  # we can write the logic in Project model itself
    #   # @projects = Project.where("title LIKE?", "%" + params[:q] + "%")
    #   @projects = Project.where("title LIKE?", "%#{@query}%").page params[:page]
    # end

    @query = params[:q] ||= ""
    @projects = Project.where("title LIKE?", "%#{@query}%").page params[:page]

    render "index"
    
    # respond_to do |format|
    #   format.js   { render :index }
    #   format.html { render :index }
    # end

  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)
    @project.user_id = current_user.id

    respond_to do |format|
      if @project.save
        ExpireProjectJob.set(wait_until: @project.expires_at).perform_later(@project)
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: "Project was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id]) if params[:id] != "shoppingcart"
    end

    # Only allow a list of trusted parameters through.
    def project_params
      params.require(:project).permit(:title, :price, :price_cents, :currency, :donation_goal, :description, :thumbnail)
    end

end
