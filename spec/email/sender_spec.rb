require 'spec_helper'
require 'tackle_box/email/sender'

describe TackleBox::Email::Sender do
  let(:domains) do
    {
      'lurkedin.com'    => {
        address:              'mail.lurkedin.com',
        port:                 587,
        user_name:            'test',
        password:             'test',
        authentication:       :plain,
        enable_starttls_auto: true
      },

      'trailofbits.com' => {
        address:              'mail.trailofbits.com',
        port:                 587,
        user_name:            'test',
        password:             'test',
        authentication:       :plain,
        enable_starttls_auto: true
      }
    }
  end

  subject { described_class.new(domains) }

  describe "#initialize" do
    it "should set domains" do
      expect(subject.domains).to be domains
    end
  end

  describe "#send" do
    let(:email) do
      double('Mail::Message', from_addrs: ['hal@trailofbits.com'])
    end

    let(:expected_credentials) { domains['trailofbits.com'] }

    before do
      allow(email).to receive(:deliver)
    end

    it "should select the credentials based on the from domain" do
      expect(email).to receive(:delivery_method).with(
        :smtp, expected_credentials
      )

      subject.send(email)
    end
  end
end
