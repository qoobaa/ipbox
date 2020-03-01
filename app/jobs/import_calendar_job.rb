class ImportCalendarJob < ApplicationJob
  def perform(project)
    project.file.open do |calendar|
      Zip::File.open(calendar.path) do |io|
        io.entries.select { |entry| entry.name =~ /\.ics$/ }.each do |calendar_entry|
          Icalendar::Calendar.parse(calendar_entry.get_input_stream).each do |calendar|
            calendar.events.each do |event|
              if event.dtstart.is_a?(Icalendar::Values::Date)
                (event.dtstart..event.dtend).each do |day|
                  Entry.create(
                    external_id: "#{day}-event.uid",
                    ended_at: day,
                    hours: 8,
                    description: event.summary,
                    project_id: project.id,
                    type: project.default_type,
                    user_id: project.user_id
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
                  description: event.summary,
                  project_id: project.id,
                  type: project.default_type,
                  user_id: project.user_id
                )
              end
            end
          end
        end
      end
    end
    ActionCable.server.broadcast("imports-#{project.id}", entries: project.entries.size)
  end
end
