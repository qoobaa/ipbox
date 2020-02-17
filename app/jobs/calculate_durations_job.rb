class CalculateDurationsJob < ApplicationJob
  def perform
    beginning_of_year = Date.parse("2019-01-01")
    end_of_year = Date.parse("2019-12-31")
    hours_per_day = 8

    (beginning_of_year..end_of_year).each do |day|
      daily_entries = Entry.where("committed_at::TIMESTAMP::DATE = ?", day).order(committed_at: :asc)

      next if daily_entries.blank?

      # FIXME: handle the case when previous is nil
      previous_entry = daily_entries.first.previous

      [previous_entry, *daily_entries].each_cons(2) do |previous, current|
        hours = (current.committed_at - previous.committed_at) / 3600.0
        duration = case hours
                   when (..0.5) then 0.5
                   when (0.5..hours_per_day) then hours.round
                   when (hours_per_day..) then hours_per_day
                   end

        current.update!(duration: duration)
      end

      # adjust the first entry
      if daily_entries.sum(:duration) > hours_per_day
        first_duration = hours_per_day - daily_entries.sum(:duration) + daily_entries.first.duration
        daily_entries.first.update!(duration: [0.5, first_duration].max)
      end
    end
  end
end
