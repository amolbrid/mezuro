include OwnershipAuthentication

class ProjectsController < ApplicationController
  before_action :authenticate_user!,
    except: [:index, :show]
  before_action :check_project_ownership, only: [:edit, :update, :destroy]

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects
  # GET /projects.json
  def index
    @projects = Project.all
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    respond_to do |format|
      create_and_redir(format)
    end
  end

  # GET /project/1
  # GET /project/1.json
  def show
    set_project
    @project_repositories = @project.repositories
  end

  # GET /projects/1/edit
  # GET /projects/1/edit.json
  def edit
    set_project
  end 

  def update
    set_project
    if @project.update(project_params)
      redirect_to(project_path(@project.id))
    else
      render "edit"
    end
  end

  # DELETE /project/1
  # DELETE /project/1.json
  def destroy
    set_project
    current_user.project_ownerships.find_by_project_id(@project.id).destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params[:project]
    end

    # Extracted code from create action
    def create_and_redir(format)
      if @project.save
        current_user.project_ownerships.create project_id: @project.id

        format.html { redirect_to project_path(@project.id), notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
end
