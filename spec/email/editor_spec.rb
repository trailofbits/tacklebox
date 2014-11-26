require 'spec_helper'
require 'tackle_box/email/editor'

describe TackleBox::Email::Editor do
  let(:email) { File.join(File.dirname(__FILE__),'email.eml') }

  subject { described_class.new(email) }

  describe "#initialize" do
    it "should set path" do
      expect(subject.path).to be email
    end

    it "should parse the email" do
      expect(subject.email.class).to be Mail::Message
      expect(subject.email.to_s).to be == File.read(email)
    end
  end

  describe "#edit" do
    it "should yield the email" do
      expect { |b| subject.edit(&b) }.to yield_with_args(subject.email)
    end
  end

  describe "#edit_body_parts" do
    it "should return an Enumerator if no block is given" do
      expect(subject.edit_body_parts.class).to be Enumerator
    end

    context "when the email multiple body parts" do
      let(:email) { File.join(File.dirname(__FILE__),'multipart_email.eml') }

      it "should yield each text/plain and text/html part" do
        expect { |b|
          subject.edit_body_parts(&b)
        }.to yield_successive_args(*subject.email.parts)
      end
    end

    context "when the email only has one body part" do
      let(:email) { File.join(File.dirname(__FILE__),'email.eml') }

      it "should yield the email itself" do
        expect { |b| subject.edit_body_parts(&b) }.to yield_with_args(subject.email)
      end
    end
  end

  describe "#dequote" do
    let(:email) do
      File.join(File.dirname(__FILE__),'quoted_printable_email.eml')
    end

    let(:unquoted_email) do
      Mail.read(File.join(File.dirname(__FILE__),'email.eml'))
    end

    before { subject.dequote }

    it "should set Content-Transfer-Encoding to '7bit'" do
      expect(subject.email.content_transfer_encoding).to be == '7bit'
    end

    it "should dequote the body" do
      expect(subject.email.body.to_s).to be == unquoted_email.body.to_s
    end
  end

  describe "#replace" do
    it "should find and replace text in the headers" do
      subject.replace('Dan Guido','Nick De')

      expect(subject.email.header.raw_source).to_not include('Dan Guido')
    end

    it "should find and replace text in the body" do
      subject.replace('nudes','nudez')

      expect(subject.email.body.to_s).to_not include('nudes')
    end
  end

  describe "#replace_name" do
    let(:old_first_name) { 'Hal' }
    let(:old_last_name)  { 'Brodigan' }
    let(:old_name) { "#{old_first_name} #{old_last_name}" }

    let(:new_first_name) { 'Nick' }
    let(:new_last_name)  { 'Depetrillo' }
    let(:new_name) { "#{new_first_name} #{new_last_name}" }

    before { subject.replace_name(old_name,new_name) }

    it "should replace all instances of the old name" do
      expect(subject.email.to_s).to_not include(old_name)
      expect(subject.email.to_s).to     include(new_name)
    end

    it "should replace all instances of the old last name" do
      expect(subject.email.to_s).to_not include(old_last_name)
      expect(subject.email.to_s).to     include(new_last_name)
    end

    it "should replace all instances of the old first name" do
      expect(subject.email.to_s).to_not include(old_first_name)
      expect(subject.email.to_s).to     include(new_first_name)
    end
  end

  describe "#replace_from" do
    let(:old_from) { 'hal@trailofbits.com'  }
    let(:new_from) { 'nick@trailofbits.com' }

    before { subject.replace_from(new_from) }

    it "should replace the from address" do
      expect(subject.email.to_s).to_not include(old_from)
      expect(subject.email.from).to     include(new_from)
    end

    context "with no argument" do
      let(:new_from) { '{{ from.address }}' }

      before { subject.replace_from }

      it "should replace the from address with '{{ from.address }}'" do
        expect(subject.email.to_s).to_not include(old_from)
        expect(subject.email.from).to     include(new_from)
      end
    end
  end

  describe "#replace_from_name" do
    let(:old_from_name) { 'Hal Brodigan'  }
    let(:new_from_name) { 'Nick De' }

    before { subject.replace_from_name(new_from_name) }

    it "should replace the from address" do
      expect(subject.email.to_s).to_not include(old_from_name)
      expect(subject.email.header[:from].address_list.addresses.first.display_name).to be == new_from_name
    end

    context "with no argument" do
      let(:new_from_name) { '{{ from.name }}' }

      before { subject.replace_from_name }

      it "should replace the from address with '{{ from.address }}'" do
        expect(subject.email.to_s).to_not include(old_from_name)
        expect(subject.email.header[:from].address_list.addresses.first.display_name).to be == new_from_name
      end
    end
  end

  describe "#replace_to" do
    let(:old_to) { 'dan@trailofbits.com'  }
    let(:new_to) { '{{ to.address }}' }

    before { subject.replace_to }

    it "should replace the to address with '{{ to.address }}'" do
      expect(subject.email.to_s).to_not include(old_to)
      expect(subject.email.to).to       include(new_to)
    end
  end

  describe "#replace_to_name" do
    let(:old_to_name) { 'Dan Guido'  }
    let(:new_to_name) { '{{ to.name }}' }

    before { subject.replace_to_name }

    it "should replace the to address with '{{ to.address }}'" do
      expect(subject.email.to_s).to_not include(old_to_name)
      expect(subject.email.header[:to].address_list.addresses.first.display_name).to be == new_to_name
    end
  end

  describe "#replace_domain" do
    let(:old_domain) { 'imgur.com'  }
    let(:new_domain) { 'imdurr.com' }

    before { subject.replace_domain(old_domain,new_domain) }

    it "should replace every domain with the new domain" do
      expect(subject.email.to_s).to_not include(old_domain)
      expect(subject.email.to_s).to     include(new_domain)
    end
  end

  describe "#to_s" do
    it "should return the edited email" do
      expect(subject.to_s).to be == subject.email.to_s
    end
  end
end
