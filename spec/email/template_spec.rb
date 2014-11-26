require 'spec_helper'

require 'tackle_box/email/template'

describe TackleBox::Email::Template do
  let(:file) { File.join(File.dirname(__FILE__),'email_template.eml') }

  describe ".open" do
    subject { described_class.open(file) }

    let(:contents) { File.read(file) }

    it "should load the contents of the file" do
      expect(subject.email).to be == contents
    end
  end

  subject { described_class.open(file) }

  describe "#requires_to?" do
    it "should check for '{{ to.'" do
      expect(subject.email).to receive(:include?).with('{{ to.').and_return(true)

      subject.requires_to?
    end
  end

  describe "#requires_from?" do
    it "should check for '{{ from.'" do
      expect(subject.email).to receive(:include?).with('{{ from.').and_return(true)

      subject.requires_from?
    end
  end

  describe "#requires_link?" do
    it "should check for '{% link %}' first" do
      expect(subject.email).to receive(:include?).with('{% link %}').and_return(true)

      subject.requires_link?
    end
  end

  describe "#requires_attachment?" do
    it "should check for '{% attachment %}' first" do
      expect(subject.email).to receive(:include?).with('{% attachment %}').and_return(false)
      expect(subject.email).to receive(:include?).with('{{ attachment.').and_return(false)

      subject.requires_attachment?
    end
  end

  describe "#render" do
    subject { super().render(variables) }

    let(:name)  { "Dan Guido" }
    let(:token) { 'jfsjlfsjl' }
    let(:link)  { 'http://lurkdin.com/uas/request-password-reset?trk=signin_fpwd' }

    let(:variables) do
      {
        'to' => {
          'name'    => name,
          'address' => 'dan@trailofbits.com'
        },
        'from' => {
          'name'    => 'Nick De',
          'address' => 'nick@trailofberts.com'
        },
        'token' => token,
        'link'  => URI(link)
      }
    end

    let(:expected_html) do
      %{
<html>
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <title>test email</title>
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    Checkout these <a href="#{link}&token=#{token}">nudes</a>.<br>
  </body>
</html>
      }.strip << "\n"
    end

    let(:expected_to) do
      "#{variables['to']['name']} <#{variables['to']['address']}>"
    end

    let(:expected_from) do
      "#{variables['from']['name']} <#{variables['from']['address']}>"
    end

    let(:expected_subject) { "Hello, #{name}" }

    it "should render the headers" do
      expect(subject.header[:to].value).to      be == expected_to
      expect(subject.header[:from].value).to    be == expected_from
      expect(subject.header[:subject].value).to be == expected_subject
    end

    it "should render the body" do
      expect(subject.body.decoded).to be == expected_html
    end

    context "when the email template is multi-part" do
      let(:file) { File.join(File.dirname(__FILE__),'multipart_email_template.eml') }

      let(:expected_txt) do
        %{Checkout these nudes (#{link}&token=#{token}).}
      end

      it "should render any text/plain body parts" do
        expect(subject.body.parts[0].decoded).to be == expected_txt
      end

      it "should render any text/html body parts" do
        expect(subject.body.parts[1].decoded).to be == expected_html
      end
    end
  end
end
