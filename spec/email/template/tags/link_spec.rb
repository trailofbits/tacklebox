require 'spec_helper'

require 'tackle_box/email/template/tags/link'

describe TackleBox::Email::Template::Tags::Link do
  let(:template) { Liquid::Template.parse('{% link %}') }

  let(:link) { 'http://apt.trailofbits.com/uas/request-password-reset?trk=signin_fpwd' }
  let(:url)  { URI(link) }

  let(:param) { described_class::TOKEN_PARAM }
  let(:token) { 'jkfsjls' }

  context "when 'link' is set" do
    let(:context) do
      Liquid::Context.new({
        'token' => token,
        'link'  => {
          'scheme' => url.scheme,
          'host'   => url.host,
          'port'   => url.port,
          'path'   => url.path,
          'query'  => url.query
        }
      })
    end

    subject { template.render(context) }

    it "should add the original link" do
      expect(subject).to include(link)
    end

    context "when the link has existing query params" do
      it "should append the tracking query parameter and recipient token" do
        expect(subject).to include("&#{param}=#{token}")
      end
    end

    context "when the link does not have query params" do
      before { url.query = nil }

      it "should set the tracking query parameter and recipient token" do
        expect(subject).to include("?#{param}=#{token}")
      end
    end

    context "when link_shortener is set" do
      before { context['link_shortener'] = 'tinyurl' }

      it "should shorten the resulting link" do
        expect(subject).to include("http://tinyurl.com/")
      end
    end
  end

  context "when 'link' is not set" do
    let(:context) { Liquid::Context.new }

    subject { template.render(context) }

    it "should add a random greeting" do
      expect(subject).to be == ''
    end
  end
end
