class Entry < ApplicationRecord
  enum type: {development: 1, maintenance: 2}

  self.inheritance_column = nil

  def previous
    self.class.where("committed_at < ?", committed_at).order(committed_at: :asc).last
  end
end
