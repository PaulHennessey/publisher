class Downtime
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :start_time, type: DateTime
  field :end_time, type: DateTime

  belongs_to :artefact, optional: true

  validate :start_time_precedes_end_time
  validate :end_time_is_in_future, on: :create
  validates :message, :start_time, :end_time, :artefact, presence: true

  def self.for(artefact)
    where(artefact_id: artefact.id).first
  end

  def publicise?
    Time.zone.now.between?(display_start_time, end_time)
  end

  def display_start_time
    start_time.yesterday.at_midnight
  end

private

  def end_time_is_in_future
    errors.add(:end_time, "End time must be in the future") if end_time && !end_time.future?
  end

  def start_time_precedes_end_time
    errors.add(:start_time, "Start time must be earlier than end time") if start_time && end_time && start_time >= end_time
  end
end
