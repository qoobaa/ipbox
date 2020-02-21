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
    @entries = ImportEntriesJob.perform_now(@project, request.raw_post)
    AssociateEntriesWithInvoicesJob.perform_now
    CalculateHoursJob.perform_now
    ActionCable.server.broadcast("imports-#{@project.id}", entries: @entries.size)
    head :no_content
  end

  def upload
    @project = Project.find(params[:id])
    calendar = params[:project][:calendar]
    Zip::File.open(calendar) do |io|
      io.entries.select { |entry| entry.name =~ /\.ics$/ }.each do |calendar_entry|
        Icalendar::Calendar.parse(calendar_entry.get_input_stream).each do |calendar|
          calendar.events.each do |event|
            if event.dtstart.is_a?(Icalendar::Values::Date)
              (event.dtstart..event.dtend).each do |day|
                Entry.create(
                  external_id: "#{day}-event.uid",
                  ended_at: day,
                  hours: 8,
                  message: event.summary,
                  project_id: @project.id,
                  type: @project.default_type
                )
              end
            else
              hours = (event.dtend - event.dtstart) / 3600.0
              hours = hours < 0.5 ? 0.5 : hours.round

              Entry.create(
                exact: true,
                external_id: event.uid,
                ended_at: event.dtend,
                hours: hours,
                message: event.summary,
                project_id: @project.id,
                type: @project.default_type
              )
            end
          end
        end
      end
    end
    AssociateEntriesWithInvoicesJob.perform_now
    redirect_to entries_path(q: {project_id_eq: @project.id})
  end

  private

  def project_params
    params.require(:project).permit(:name, :default_type)
  end
end
