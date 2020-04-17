CSV.generate(headers: ["Data", "Opis", "Typ", "Liczba godzin"], write_headers: true) do |csv|
  @invoice.entries.order(:day).each do |entry|
    csv << [entry.day, entry.description, entry.type, entry.hours]
  end
end
