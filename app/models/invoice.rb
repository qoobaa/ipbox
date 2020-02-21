class Invoice < ApplicationRecord
  has_many :entries

  validates :number, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :hours, presence: true

  after_save :associate_entries

  def period
    (from..to)
  end

  private

  def associate_entries
    entries = Entry.where("ended_at::TIMESTAMP::DATE >= ?", from).where("ended_at::TIMESTAMP::DATE <= ?", to)
    entries.update_all(invoice_id: id)
  end
end
