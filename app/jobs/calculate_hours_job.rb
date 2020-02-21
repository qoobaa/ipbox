class CalculateHoursJob < ApplicationJob
  def perform
    beginning_of_year = Date.parse("2019-01-01")
    end_of_year = Date.parse("2019-12-31")
    hours_per_day = 8

    (beginning_of_year..end_of_year).each do |day|
      daily_entries = Entry.where("ended_at::TIMESTAMP::DATE = ?", day).order(ended_at: :asc)

      next if daily_entries.blank?

      previous_entry = daily_entries.first.previous

      [previous_entry, *daily_entries].each_cons(2) do |previous, current|
        next if current.exact?

        # handle the case when previous is nil
        previous_ended_at = previous ? previous.ended_at : DateTime.parse("2019-01-01")

        hours = (current.ended_at - previous_ended_at) / 3600.0
        hours = case hours
                when (..0.5) then 0.5
                when (0.5..hours_per_day) then hours.round
                when (hours_per_day..) then hours_per_day
                end

        current.update!(hours: hours)
      end

      # adjust the first entry
      if daily_entries.sum(:hours) > hours_per_day
        first_hours = hours_per_day - daily_entries.sum(:hours) + daily_entries.first.hours
        daily_entries.first.update!(hours: [0.5, first_hours].max) unless daily_entries.first.exact?
      end
    end
  end
end
