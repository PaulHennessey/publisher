require "gds_api/publishing_api"

module Services
  def self.publishing_api
    @publishing_api ||= GdsApi::PublishingApi.new(Plek.find("publishing-api"))
  end
end
