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
      redirect_to projects_path
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
      @entries = ImportEntriesJob.perform_now(@project, request.raw_post)
      CalculateHoursJob.perform_now
      ActionCable.server.broadcast("imports-#{@project.id}", entries: @entries.size)
      render body: "pomyślnie zaimportowano #{@entries.count} wpisów\n"
    end
  end

  def upload
    @project = Project.find(params[:id])
    @project.update(file: params[:project][:file])
    ImportCalendarJob.perform_now(@project)
    AssociateEntriesWithInvoicesJob.perform_now
    redirect_to entries_path(q: {project_id_eq: @project.id})
  end

  private

  def project_params
    params.require(:project).permit(:name, :default_type)
  end
end
