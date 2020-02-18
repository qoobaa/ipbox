class Entry < ApplicationRecord
  self.inheritance_column = nil

  enum type: {development: 1, maintenance: 2}
  belongs_to :invoice, optional: true
  belongs_to :repository

  validates :sha, uniqueness: {scope: :invoice_id}
  validates :manual, inclusion: {in: [true, false]}

  def self.unassigned
    where(invoice_id: nil)
  end

  def self.by_year(year)
    beginning_of_year = "#{year}-01-01"
    end_of_year = "#{year}-12-31"
    where("committed_at >= ?", beginning_of_year).where("committed_at <= ?", end_of_year)
  end

  def previous
    self.class.where("committed_at < ?", committed_at).order(committed_at: :asc).last
  end
end
