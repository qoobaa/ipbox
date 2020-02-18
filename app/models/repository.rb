class Repository < ApplicationRecord
  has_many :entries, dependent: :destroy

  enum default_type: {development: 1, maintenance: 2}

  validates :name, presence: true
  validates :default_type, presence: true
end
