require "edition"
require "parted"

class ProgrammeEdition < Edition
  include Parted

  before_save :setup_default_parts, if: :new_record?

  GOVSPEAK_FIELDS = [].freeze

  DEFAULT_PARTS = [
    { title: "Overview", slug: "overview" },
    { title: "What you'll get", slug: "what-youll-get" },
    { title: "Eligibility", slug: "eligibility" },
    { title: "How to claim", slug: "how-to-claim" },
    { title: "Further information", slug: "further-information" },
  ].freeze

  def setup_default_parts
    if parts.empty?
      DEFAULT_PARTS.each do |part|
        parts.build(title: part[:title], slug: part[:slug], body: "")
      end
    end
  end
end
