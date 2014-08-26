require "csv"
require "date"

class CsvHashConverter

  def initialize(csv)
    @csv = csv
  end

  def csv_to_hash
    hash = {}
    CSV.foreach(@csv, :headers => true) do |row|
      if hash.keys.include?(row.fields[0])
        hash[row.fields[0]] << Hash[row.headers[1..-1].zip(row.fields[1..-1])]
      else
        hash[row.fields[0]] = []
        hash[row.fields[0]] << Hash[row.headers[1..-1].zip(row.fields[1..-1])]
      end
    end
    hash
  end

end