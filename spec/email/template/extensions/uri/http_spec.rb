require 'spec_helper'

require 'tackle_box/email/template/extensions/uri/http'

describe URI::HTTP do
  let(:link) { "http://lurkdin.com/uas/request-password-reset?trk=signin_fpwd" }
  let(:uri)  { URI(link) }

  subject { uri }

  describe "#to_liquid" do
    subject { super().to_liquid }

    it "should include 'url'" do
      expect(subject['url']).to be == link
    end

    [:scheme, :host, :port, :path, :query].each do |component|
      it "should include '#{component}'" do
        expect(subject[component.to_s]).to be == uri.send(component)
      end
    end
  end
end
