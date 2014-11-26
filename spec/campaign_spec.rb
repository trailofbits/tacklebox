require 'spec_helper'
require 'tackle_box/campaign'

describe TackleBox::Campaign do
  let(:organization) do
    Organization.new(
      'Trail of Bits, LLC',
      domain:   'trailofbits.com',
      website:  'http://www.trailofbits.com/',
      industry: 'Information Security'
    )
  end

  let(:to) do
    Person.new('dan@trailofbits.com', name:       'Dan Guido',
                                      title:      'CEO',
                                      department: 'Management',
                                      location:   'New York, NY')
  end

  let(:from) do
    Person.new('nick@trailofberts.com', name:       'Nick De',
                                        title:      'Chief Twitter Strategist',
                                        department: 'Sales',
                                        location:   'New York, NY')
  end

  let(:email_template) do
    Email::Template.open(File.join(File.dirname(__FILE__),'email','multipart_email_template.eml'))
  end

  let(:link) { 'http://lurkdin.com/uas/request-password-reset?trk=signin_fpwd' }

  let(:attachment) do
    {
      name:    'nudes.jpg',
      content: 'infected'
    }
  end

  subject do
    described_class.new(email_template, organization, link:    link,
                                                      account: from)
  end

  describe "#initialize" do
    context "when a link option is given" do
      it "should initialize a Link object" do
        expect(subject.link.to_s).to be == link
      end
    end

    context "when an attachment option is given" do
      subject do
        described_class.new(email_template,organization, link:       link,
                                                         attachment: attachment,
                                                         account:    from)
      end

      it "should initialize an Attachment object" do
        expect(subject.attachment.name).to    be == attachment[:name]
        expect(subject.attachment.content).to be == attachment[:content]
      end
    end
  end

  describe "#to_liquid" do
    let(:liquid) { subject.to_liquid }

    it "should contain the organization hash" do
      expect(liquid['organization']).to be == organization.to_liquid
    end

    context "when #link is set" do
      it "should include a link hash" do
        expect(liquid['link']).to be == subject.link.to_liquid
      end
    end

    context "when #attachment is set" do
      subject do
        described_class.new(email_template,organization, link:       link,
                                                         attachment: attachment,
                                                         account:    from)
      end

      it "should include an attachment hash" do
        expect(liquid['attachment']).to be == subject.attachment.to_liquid
      end
    end
  end
end
