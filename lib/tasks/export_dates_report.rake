desc "Export Published Mainstream Content title and URL between 2 dates, as CSV"

task :export_dates_report, %i[start_date end_date] => :environment do |_, args|
  usage_message = "usage: rake export_dates_report[<start_date>, <end_date>]\n"\
    "dates format: YYYY-MM-DD".freeze
  abort usage_message unless args[:start_date] && args[:end_date]
  begin
    start_date = Date.parse(args[:start_date])
    end_date = Date.parse(args[:end_date])
  rescue ArgumentError
    abort usage_message
  end

  path = CsvReportGenerator.csv_path
  DatesReportPresenter.new(start_date, end_date).write_csv(path)

  puts "Report successfully generated inside #{path} !"
end
