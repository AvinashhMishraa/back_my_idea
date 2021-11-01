class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, except: [:index, :show, :add_to_cart, :remove_from_cart]

  # before_action :force_json, only: :search

  # GET /projects or /projects.json
  def index
    @titles = Project.pluck(:title)
    @projects = Project.page params[:page]
    # @query = params[:q] ||= ""
    # @projects = Project.where("title LIKE?", "%#{@query}%").page params[:page]

    respond_to do |format|
      format.html
      # format.json  { render :json => @projects }
      # format.js { render 'index.js.erb' }
      format.js
      # format.json{ render json: @titles}
    end
  end

  def search
    ############################## with elasticsearch-searckick ############################

    # @query = params[:q] ||= ""
    # project_ids = []

    # #@projects = Project.search(@query, fields: ["title^4", "status"], match: :word_middle, page: params[:page], per_page: 3, misspellings: {edit_distance: 3})
    
    # # @results = Searchkick.search(@query, match: :word_middle, misspellings: {edit_distance: 3}, models: [Project, Comment])

    # @results = Searchkick.search(@query, fields: ["title", "status", "body"], match: :word_middle, misspellings: {edit_distance: 3}, models: [Project, Comment])

    # @results.hits.each_with_index do |result, idx|
    #   if result["_index"].include? "comment"
    #     project_ids << Project.find(Comment.find(result["_id"]).commentable_id).id
    #   else
    #     project_ids << Project.find(result["_id"]).id
    #   end
    # end

    # project_ids << ActionText::RichText.all.where("body LIKE ?", "%#{@query}%".downcase).pluck(:record_id)

    # @projects = Project.where(id: project_ids.flatten).page params[:page]

    # # render "index"


    # respond_to do |format|
    #   format.html { render "index.html.erb"}
    #   format.js { render "search.js.erb" }
    # end

    ############################## without elasticsearch-searckick ############################

    # if params[:q].blank?
    #   @projects = Project.page params[:page]
    # else
    #   @query = params[:q]
    #   # @projects = Project.search(params[:q]).page params[:page]  # we can write the logic in Project model itself
    #   # @projects = Project.where("title LIKE?", "%" + params[:q] + "%")
    #   @projects = Project.where("LOWER(title) LIKE?", "%#{@query}%".downcase).page params[:page]
    # end

    # @projects = Project.where("LOWER(title) LIKE?", "%#{@query}%".downcase).page params[:page]

    @query = params[:q] ||= ""
    @projects = Project.search(params[:q]).page params[:page]  # we can write the logic in Project model itself

    # render "index"
    # render json: {project_titles: @projects.pluck(:title)}
    @all_projects = Project.all
    
    respond_to do |format|
      format.js   { render :search }
      format.html { render :index }
      # format.json {@project_titles = @projects.pluck(:title)}
      format.json{ render json: @all_projects}
    end



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

    # def force_json
    #   request.format = :json
    # end

end
