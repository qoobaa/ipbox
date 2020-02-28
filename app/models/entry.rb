class Entry < ApplicationRecord
  self.inheritance_column = nil

  enum type: {development: 1, maintenance: 2}
  belongs_to :invoice, optional: true
  belongs_to :project

  validates :external_id, presence: true, uniqueness: {scope: :invoice_id}
  validates :exact, inclusion: {in: [true, false]}
  validates :description, presence: true
  validates :hours, presence: true
  validates :ended_at, presence: true

  before_validation :assign_external_id
  before_save :assign_invoice

  def self.ended_on(day)
    where("ended_at BETWEEN ? AND ?", day.to_date.beginning_of_day, day.to_date.end_of_day)
  end

  def self.unassigned
    where(invoice_id: nil)
  end

  def self.by_year(year)
    where("? <= ended_at", "#{year}-01-01".to_date.beginning_of_day).where("ended_at <= ?", "#{year}-12-31".to_date.end_of_day)
  end

  def self.by_day(day)
    where("? <= ended_at", day.to_date.beginning_of_day).where("ended_at <= ?", day.to_date.end_of_day)
  end

  def self.between_days(from, to)
    where("? <= ended_at", from.to_date.beginning_of_day).where("ended_at <= ?", to.to_date.end_of_day)
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[ended_on]
  end

  def previous
    self.class.where("ended_at < ?", ended_at).order(ended_at: :asc).last
  end

  private

  def assign_external_id
    self.external_id ||= (DateTime.now.to_f * 1000 * 1000).to_i
  end

  def assign_invoice
    self.invoice = Invoice.including_day(ended_at).first
  end
end
