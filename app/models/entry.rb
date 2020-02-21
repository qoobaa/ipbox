class Entry < ApplicationRecord
  self.inheritance_column = nil

  enum type: {development: 1, maintenance: 2}
  belongs_to :invoice, optional: true
  belongs_to :project

  validates :external_id, uniqueness: {scope: :invoice_id}
  validates :exact, inclusion: {in: [true, false]}

  def self.unassigned
    where(invoice_id: nil)
  end

  def self.by_year(year)
    beginning_of_year = "#{year}-01-01"
    end_of_year = "#{year}-12-31"
    where("ended_at >= ?", beginning_of_year).where("ended_at <= ?", end_of_year)
  end

  def self.by_day(day)
    where("ended_at::TIMESTAMP::DATE = ?", day)
  end

  def previous
    self.class.where("ended_at < ?", ended_at).order(ended_at: :asc).last
  end
end
