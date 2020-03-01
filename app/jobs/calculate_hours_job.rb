class CalculateHoursJob < ApplicationJob
  def perform
    ActiveRecord::Base.transaction do
      Entry
        .where(exact: false)
        .update_all("hours = EXTRACT(EPOCH FROM ended_at - (SELECT MAX(ended_at) FROM entries e WHERE e.ended_at < entries.ended_at)) / 3600")
      Entry
        .where(exact: false)
        .where("hours < 0.25")
        .update_all("hours = 0")
      Entry
        .where(exact: false)
        .where("hours >= 0.25")
        .update_all("hours = round(hours * 2) / 2")
      Entry
        .where(exact: false)
        .where("hours = (SELECT MAX(hours) FROM entries e WHERE e.day = entries.day)")
        .update_all("hours = 8 - LEAST(8, (SELECT COALESCE(SUM(hours), 0) FROM entries e WHERE entries.day = e.day AND entries.id != e.id))")
    end
  end
end
