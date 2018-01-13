require 'csv'

# module responsible for CSV logic.
module CSVController
  def self.read_en_ru(file_name)
    result = {}
    CSV.foreach(file_name, headers: true, skip_blanks: true) do |row|
      result = result.merge(row['en'] => row['ru'])
    end
    result
  end

  def self.read_ru_en(file_name)
    result = {}
    CSV.foreach(file_name, headers: true, skip_blanks: true) do |row|
      result = result.merge(row['ru'] => row['en'])
    end
    result
  end

  def self.write_to_file(file_name, rows, headers)
    CSV.open(file_name, 'w') do |csv|
      csv << headers
      rows.each do |key, value|
        csv << [key, value]
      end
    end
  end
end
