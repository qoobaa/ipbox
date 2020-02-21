module InvoiceHelper
  def invoice_row_classes(invoice)
    "".tap do |classes|
      classes << 'table-danger' if invoice.entries.sum(:hours) > invoice.hours
      classes << 'table-warning' if invoice.entries.sum(:hours) < invoice.hours
      classes << 'table-success' if invoice.entries.sum(:hours) == invoice.hours
    end
  end
end
