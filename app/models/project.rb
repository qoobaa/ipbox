class Project < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_one_attached :file

  enum default_type: {development: 1, maintenance: 2}

  validates :name, presence: true
  validates :default_type, presence: true
end
