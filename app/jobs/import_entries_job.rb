class ImportEntriesJob < ApplicationJob
  def perform(project, raw_post)
    attributes = raw_post.lines.map do |line|
      [:external_id, :ended_at, :description].zip(line.chomp.split(" ", 3)).to_h.tap do |attributes|
        attributes[:project_id] = project.id
        attributes[:type] = project.default_type
        attributes[:hours] = 0.5
        attributes[:user_id] = project.user_id
      end
    end
    entries = Entry.create(attributes).select(&:valid?)
    CalculateHoursJob.perform_now(project.user)
    ActionCable.server.broadcast("imports-#{project.id}", entries: entries.size)
  end
end
