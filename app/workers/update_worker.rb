class UpdateWorker
  include Sidekiq::Worker

  def perform(edition_id, publish = false) # rubocop:disable Style/OptionalBooleanParameter
    edition = Edition.find(edition_id)
    UpdateService.call(edition)
    PublishService.call(edition) if publish
  end
end
