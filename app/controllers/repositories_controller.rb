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

  def import
    @repository = Repository.find(params[:id])
    if request.post?
      @entries = ImportEntriesJob.perform_now(@repository, request.raw_post)
      AssociateEntriesWithInvoicesJob.perform_now
      CalculateHoursJob.perform_now
      ActionCable.server.broadcast("imports-#{@repository.id}", entries: @entries.size)
      head :no_content
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:name, :default_type)
  end
end
