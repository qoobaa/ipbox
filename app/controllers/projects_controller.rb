# coding: utf-8
class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:import]
  skip_before_action :authenticate_user!, only: [:import]
  before_action :assign_user

  def index
    @projects = @user.projects.all
  end

  def new
    @project = @user.projects.build
  end

  def create
    @project = @user.projects.build(project_params)
    if @project.save
      redirect_to edit_project_path(@project)
    end
  end

  def edit
    @project = @user.projects.find(params[:id])
  end

  def import
    @project = Project.find_by(uuid: params[:id])

    if @project.entries.count > 0
      render body: "niepowodzenie: projekt zawiera wpisy\n"
    else
      ImportEntriesJob.perform_later(@project, request.raw_post)
      render body: "sukces: zaimportowano wpisy\n"
    end
  end

  def upload
    @project = @user.projects.find(params[:id])
    @project.update(file: params[:project][:file])
    ImportCalendarJob.perform_later(@project)
    head :ok
  end

  private

  def assign_user
    @user = current_user
  end

  def project_params
    params.require(:project).permit(:name, :default_type)
  end
end
