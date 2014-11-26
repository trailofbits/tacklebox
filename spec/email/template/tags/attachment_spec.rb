require 'spec_helper'

require 'tackle_box/email/template/tags/attachment'

describe TackleBox::Email::Template::Tags::Attachment do
  subject { Liquid::Template.parse('{% attachment %}') }

  let(:attachment) { 'foo.zip' }

  context "when 'attachment' is set" do
    let(:context) do
      Liquid::Context.new({'attachment' => {'name' => attachment}})
    end

    it "should add a random greeting" do
      expect(subject.render(context)).to eq(attachment)
    end

    context "when 'attachment_password' is also set" do
      let(:attachment_password) { 'secret' }
      let(:context) do
        Liquid::Context.new({
          'attachment' => {
            'name'     => attachment,
            'password' => attachment_password
          }
        })
      end

      it "should add a random greeting" do
        expect(subject.render(context)).to match(/^#{attachment} \(#{Regexp.union(described_class::TEXT)} #{attachment_password}\)$/)
      end
    end
  end

  context "when 'attachment' is not set" do
    let(:context) { Liquid::Context.new }

    it "should add a random greeting" do
      expect(subject.render(context)).to eq('')
    end
  end
end
