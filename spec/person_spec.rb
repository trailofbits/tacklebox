require 'spec_helper'

require 'tackle_box/person'

describe TackleBox::Person do
  let(:name)       { "Dan Guido" }
  let(:address)    { "dan@trailofbits.com" }
  let(:title)      { "CEO" }
  let(:department) { "Management" }
  let(:location)   { 'New York, NY' }

  subject do
    described_class.new(address, name:       name,
                                 title:      title,
                                 department: department,
                                 location:   location)
  end

  describe "#initialize" do
    subject do
      described_class.new(address, name: name)
    end

    it "should set address" do
      expect(subject.address).to be address
    end

    context "when name is given" do
      subject do
        described_class.new(address,name: name)
      end

      it "should set name" do
        expect(subject.name).to be name
      end
    end

    context "when title is given" do
      subject do
        described_class.new(address,title: title)
      end

      it "should set title" do
        expect(subject.title).to be title
      end
    end

    context "when department is given" do
      subject do
        described_class.new(address,department: department)
      end

      it "should set department" do
        expect(subject.department).to be department
      end
    end

    context "when location is given" do
      subject do
        described_class.new(address,location: location)
      end

      it "should set location" do
        expect(subject.location).to be location
      end
    end
  end

  describe "#to_liquid" do
    subject { super().to_liquid }

    it "should include name" do
      expect(subject['name']).to be == name
    end

    it "should include address" do
      expect(subject['address']).to be == address
    end

    it "should include title" do
      expect(subject['title']).to be == title
    end

    it "should include department" do
      expect(subject['department']).to be == department
    end

    it "should include the location" do
      expect(subject['location']).to be == location
    end
  end

  describe "#to_s" do
    context "when name is omitted" do
      subject { described_class.new(address) }

      it "should return the address" do
        expect(subject.to_s).to be == address
      end
    end

    context "when #name is set" do
      subject { described_class.new(address, name: name) }

      it "should == 'name <address>'" do
        expect(subject.to_s).to be == "#{name} <#{address}>"
      end
    end
  end
end
