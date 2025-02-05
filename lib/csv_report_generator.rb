require "redis"
require "redis-lock"

class CsvReportGenerator
  def self.csv_path
    ENV["GOVUK_APP_ROOT"] ||= Rails.root
    File.join(ENV["GOVUK_APP_ROOT"], "reports")
  end

  def run!
    Redis.new.lock("publisher:#{Rails.env}:report_generation_lock", life: 15.minutes) do
      reports.each do |report|
        Rails.logger.debug "Generating #{path}/#{report.report_name}.csv"
        report.write_csv(path)
      end

      move_temporary_reports_into_place
    end
  rescue Redis::Lock::LockNotAcquired => e
    Rails.logger.debug("Failed to get lock for report generation (#{e.message}). Another process probably got there first.")
  end

  def reports
    @reports ||= [
      EditorialProgressPresenter.new(
        Edition.not_in(state: %w[archived]),
      ),

      EditionChurnPresenter.new(
        Edition.not_in(state: %w[archived]).order(created_at: 1),
      ),

      OrganisationContentPresenter.new(
        Artefact.where(owning_app: "publisher").not_in(state: %w[archived]),
      ),

      ContentWorkflowPresenter.new(Edition.published.order(created_at: :desc)),

      AllUrlsPresenter.new(
        Artefact.where(owning_app: "publisher").not_in(state: %w[archived]),
      ),
    ]
  end

  def path
    return @path if @path

    @path = File.join(
      Dir.tmpdir,
      "publisher_reports-#{Time.zone.now.strftime('%Y%m%d%H%M%S')}-#{Process.pid}",
    )
    FileUtils.mkdir_p(@path)
    @path
  end

  def move_temporary_reports_into_place
    Dir[File.join(path, "*.csv")].each do |file|
      FileUtils.mv(file, self.class.csv_path, force: true)
    end
  end

  def redis
    Redis.new(REDIS_CONFIG)
  end
end
