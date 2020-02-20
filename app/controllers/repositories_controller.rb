class RepositoriesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:import]

  def index
    @repositories = Repository.all
  end

  def new
    @repository = Repository.new
  end

  def create
    @repository = Repository.new(repository_params)
    if @repository.save
      redirect_to repositories_path
    end
  end

  def edit
    @repository = Repository.find(params[:id])
  end

  def import
    @repository = Repository.find(params[:id])
    @entries = ImportEntriesJob.perform_now(@repository, request.raw_post)
    AssociateEntriesWithInvoicesJob.perform_now
    CalculateHoursJob.perform_now
    ActionCable.server.broadcast("imports-#{@repository.id}", entries: @entries.size)
    head :no_content
  end

  def upload
    @repository = Repository.find(params[:id])
    calendar = params[:repository][:calendar]
    Zip::File.open(calendar) do |io|
      io.entries.select { |entry| entry.name =~ /\.ics$/ }.each do |calendar_entry|
        Icalendar::Calendar.parse(calendar_entry.get_input_stream).each do |calendar|
          calendar.events.each do |event|
            if event.dtstart.is_a?(Icalendar::Values::Date)
              (event.dtstart..event.dtend).each do |day|
                Entry.create(
                  sha: "#{day}-event.uid",
                  committed_at: day,
                  hours: 8,
                  message: event.summary,
                  repository_id: @repository.id,
                  type: @repository.default_type
                )
              end
            else
              hours = (event.dtend - event.dtstart) / 3600.0
              hours = hours < 0.5 ? 0.5 : hours.round

              Entry.create(
                exact: true,
                sha: event.uid,
                committed_at: event.dtend,
                hours: hours,
                message: event.summary,
                repository_id: @repository.id,
                type: @repository.default_type
              )
            end
          end
        end
      end
    end
    AssociateEntriesWithInvoicesJob.perform_now
    redirect_to entries_path(q: {repository_id_eq: @repository.id})
  end

  private

  def repository_params
    params.require(:repository).permit(:name, :default_type)
  end
end
