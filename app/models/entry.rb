class Entry < ApplicationRecord
  self.inheritance_column = nil
  paginates_per 20

  enum type: {development: 1, maintenance: 2}
  belongs_to :invoice, optional: true
  belongs_to :project
  belongs_to :user

  validates :external_id, presence: true, uniqueness: true
  validates :exact, inclusion: {in: [true, false]}
  validates :description, presence: true
  validates :hours, presence: true, inclusion: {in: (0...24).step(0.5).to_a}
  validates :ended_at, presence: true

  before_validation :assign_day, :assign_external_id
  before_save :assign_invoice

  def self.unassigned
    where(invoice_id: nil)
  end

  def self.by_year(year)
    where("day BETWEEN ? AND ?", "#{year}-01-01".to_date, "#{year}-12-31".to_date)
  end

  def previous
    self.class.where("ended_at < ?", ended_at).order(ended_at: :asc).last
  end

  private

  def assign_day
    self.day = ended_at&.in_time_zone&.to_date
  end

  def assign_external_id
    self.external_id ||= (DateTime.now.to_f * 1000 * 1000).to_i
  end

  def assign_invoice
    self.invoice = Invoice.including_day(ended_at).first
  end
end
