class MigrateBsfLocationsToAreas < Mongoid::Migration
  def self.up
    BusinessSupportLocationMigrator.run
  end

  def self.down
    BusinessSupportEdition.excludes(state: "archived").each do |bs|
      bs.update(areas: [])
    end
  end
end
