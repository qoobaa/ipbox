class ImportEntriesJob < ApplicationJob
  def perform(repository, raw_post)
    attributes = raw_post.lines.map do |line|
      [:sha, :committed_at, :message].zip(line.chomp.split(" ", 3)).to_h.tap do |attributes|
        attributes[:repository_id] = repository.id
        attributes[:type] = repository.default_type
      end
    end
    entries = Entry.create(attributes)
    entries.select(&:valid?)
  end
end
