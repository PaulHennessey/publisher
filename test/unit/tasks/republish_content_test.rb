require "test_helper"
require "rake"

class RepublishContentTest < ActiveSupport::TestCase
  setup do
    @published_edition = FactoryBot.create(:answer_edition, state: "published")
    draft_artefact = FactoryBot.create(:draft_artefact, kind: "help_page", slug: "help/me")
    @draft_edition = FactoryBot.create(:help_page_edition, state: "draft", panopticon_id: draft_artefact.id)

    $stdout.stubs(puts: "")
  end

  context "#publishing_api:republish_content" do
    should "republish both draft and published editions" do
      Rake::Task["publishing_api:republish_content"].reenable

      RepublishWorker.expects(:perform_async).with(@published_edition.id.to_s)
      UpdateWorker.expects(:perform_async).with(@draft_edition.id.to_s)

      Rake::Task["publishing_api:republish_content"].invoke
    end
  end

  context "#publishing_api:republish_by_format" do
    should "only republish items of that format" do
      Rake::Task["publishing_api:republish_by_format"].reenable

      UpdateWorker.expects(:perform_async).with(@draft_edition.id.to_s)

      Rake::Task["publishing_api:republish_by_format"].invoke("help_page")
    end
  end
end
