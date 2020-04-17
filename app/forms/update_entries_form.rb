class UpdateEntriesForm
  include ActiveModel::Model

  attr_accessor :type, :entries, :hours, :description

  validates :hours, inclusion: {in: [nil] + (0...24).step(0.5).to_a}
  validates :type, inclusion: {in: ["", "maintenance", "development"]}

  def hours=(hours)
    @hours = hours.to_f if hours.present?
  end

  def entries_count
    entries.respond_to?(:total_count) ? entries.total_count : entries.count
  end

  def update_all
    attributes = {}

    attributes[:type] = type if type.present?
    attributes[:description] = description if description.present?
    if hours.present?
      attributes[:hours] = hours
      attributes[:exact] = true
    end

    entries.except(:limit, :offset).update_all(attributes)
  end
end
