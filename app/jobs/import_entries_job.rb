class ImportEntriesJob < ApplicationJob
  def perform(project, raw_post)
    attributes = raw_post.lines.map do |line|
      [:external_id, :ended_at, :description].zip(line.chomp.split(" ", 3)).to_h.tap do |attributes|
        attributes[:project_id] = project.id
        attributes[:type] = project.default_type
      end
    end
    entries = Entry.create(attributes)
    entries.select(&:valid?)
  end
end
