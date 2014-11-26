require 'spec_helper'

require 'tackle_box/organization'

describe TackleBox::Organization do
  let(:name) { 'Trail of Bits, LLC' }
  let(:domain) { 'trailofbits.com' }
  let(:website) { 'http://www.trailofbits.com/' }
  let(:industry) { 'Information Security' }

  subject do
    described_class.new(name, domain:   domain,
                              website:  website,
                              industry: industry)
  end

  describe "#initialize" do
    subject { described_class.new(name) }

    it "should set name" do
      expect(subject.name).to be name
    end

    context "when domain is given" do
      subject do
        described_class.new(name, domain: domain)
      end

      it "should set domain" do
        expect(subject.domain).to be domain
      end
    end

    context "when website is given" do
      subject do
        described_class.new(name, website: website)
      end

      it "should set website" do
        expect(subject.website).to be website
      end
    end

    context "when website is omitted" do
      context "when domain is given" do
        subject do
          described_class.new(name, domain: domain)
        end

        it "should derive the website from the domain" do
          expect(subject.website).to be == "http://#{domain}"
        end
      end

      context "when domain is also omitted" do
        it "should be nil" do
          expect(subject.website).to be_nil
        end
      end
    end
  end

  describe "#person" do
    let(:address) { 'dan@trailofbits.com' }
    let(:name)    { 'Dan Guido' }
    let(:title)   { 'CEO' }

    before do
      subject.person(address, name: name, title: title)
    end

    let(:person) { subject.people.last }

    it "should add a person to the organization" do
      expect(person).to_not be_nil
      expect(person.address).to be == address
      expect(person.name).to    be == name
      expect(person.title).to   be == title
    end
  end

  describe "#to_liquid" do
    subject { super().to_liquid }

    it "should have a 'name'" do
      expect(subject['name']).to be == name
    end

    it "should have a 'domain'" do
      expect(subject['domain']).to be == domain
    end

    it "should have an 'industry'" do
      expect(subject['industry']).to be == industry
    end

    it "should have a 'website'" do
      expect(subject['website']).to be == website
    end
  end

  describe "#to_s" do
    subject { super().to_s }

    it "should return the name" do
      expect(subject).to be == name
    end
  end
end
