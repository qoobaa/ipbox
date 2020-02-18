class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.string :number
      t.date :from
      t.date :to
      t.decimal :hours

      t.timestamps
    end
  end
end
