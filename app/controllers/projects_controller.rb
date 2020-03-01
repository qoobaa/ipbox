# coding: utf-8
class ProjectsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:import]

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to edit_project_path(@project)
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def import
    @project = Project.find(params[:id])

    if @project.entries.count > 0
      render body: "błąd: ten projekt został już wcześniej zaimportowany i zawiera wpisy\n"
    else
      ImportEntriesJob.perform_later(@project, request.raw_post)
      render body: "sukces: zaimportowano wpisy"
    end
  end

  def upload
    @project = Project.find(params[:id])
    @project.update(file: params[:project][:file])
    ImportCalendarJob.perform_later(@project)
    head :ok
  end

  private

  def project_params
    params.require(:project).permit(:name, :default_type)
  end
end
