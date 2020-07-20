require "ostruct"

class Area < OpenStruct
  # This list should stay in sync with Imminence's areas route constraint:
  # https://github.com/alphagov/imminence/blob/master/config/routes.rb#L13-L17
  AREA_TYPES = %w[EUR CTY DIS LBO LGD MTD UTA COI].freeze

  def self.all
    areas
  end

  def self.areas_for_edition(edition)
    areas.select { |a| edition.area_gss_codes.include?(a.codes["gss"]) }
  end

  def self.regions
    areas.select { |a| a.type == "EUR" }
  end

  def self.english_regions
    regions.select { |r| r.country_name == "England" }
  end

  def self.areas
    @areas ||= areas_with_gss_codes
  end

  def self.all_areas
    areas = []
    AREA_TYPES.each do |type|
      areas << GdsApi.imminence.areas_for_type(type)["results"].map do |area_hash|
        new(area_hash)
      end
    end
    areas.flatten
  end

  def self.areas_with_gss_codes
    all_areas.select { |a| a.codes["gss"].present? }
  end
end
