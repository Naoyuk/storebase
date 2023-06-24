require 'csv'

class CsvConverter
  attr_reader :input_file_path, :mapping, :errors

  def initialize(input_file_path, mapping)
    @input_file_path = input_file_path
    @mapping = mapping
    @errors = []
  end

  def convert_csv(output_file_path)
    raise 'No input file specified' unless input_file_path.present?
    raise 'Error: No such file or directory' unless File.exist?(input_file_path)
    raise 'Error: Permission denied' unless File.readable?(input_file_path)
    raise 'Error: Invalid file format' unless File.extname(input_file_path) == '.csv'

    CSV.open(output_file_path, 'w') do |csv|
      csv << mapping.map(&:ec_column)
      CSV.foreach(input_file_path, headers: true) do |row|
        csv << mapping.map { |m| row.fetch(m.user_column, '') }
      end
    end
  rescue => e
    add_error(e.message)
    false
  end

  private

  def format_data(data, data_type)
    # [TODO] data_typeによる各値のフォーマッター
    # convert_csvメソッドの中では以下のようにして使う
    # csv << mapping.map { |m| format_data(row.fetch(m.user_column, ''), m.data_type) }
    #
    # case data_type
    # when 0
    #   data.to_s
    # when 1
    #   '%.2f' % data.to_f
    # end
  end

  def add_error(message)
    errors << message
    false
  end
end

