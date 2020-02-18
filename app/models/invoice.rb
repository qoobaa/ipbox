class Invoice < ApplicationRecord
  has_many :entries

  validates :number, presence: true
  validates :from, presence: true
  validates :to, presence: true
  validates :hours, presence: true

  after_save :associate_entries

  private

  def associate_entries
    entries = Entry.where("committed_at::TIMESTAMP::DATE >= ?", from).where("committed_at::TIMESTAMP::DATE <= ?", to)
    entries.update_all(invoice_id: id)
  end
end
