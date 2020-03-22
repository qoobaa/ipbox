class Invoice < ApplicationRecord
  has_many :entries, dependent: :nullify
  belongs_to :user

  validates :number, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :hours, presence: true

  after_save :associate_entries

  def self.including_day(day)
    where("invoices.from <= ?", day.to_date).where("? <= invoices.to", day.to_date)
  end

  def period
    (from..to)
  end

  def ratio
    entries.development.sum(:hours) / hours
  end

  private

  def associate_entries
    user.entries.where(day: period).update_all(invoice_id: id)
  end
end
