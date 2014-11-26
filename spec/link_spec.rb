require 'spec_helper'
require 'tackle_box/link'

describe TackleBox::Link do
  let(:scheme) { 'http' }
  let(:host)   { "www.linkedin.com" }
  let(:port)   { 80 }
  let(:path)   { "/uas/request-password-reset" }
  let(:query)  { "trk=signin_fpwd" }
  let(:url)    { URI::HTTP.build([nil, host, port, path, query, nil]) }

  subject { described_class.new(url) }

  describe "#domain" do
    it "should return the host from the link" do
      expect(subject.domain).to be == host
    end
  end

  describe "#to_liquid" do
    subject { super().to_liquid }

    it "should contain the full url" do
      expect(subject['url']).to be == url.to_s
    end

    it "should contain a scheme" do
      expect(subject['scheme']).to be == scheme
    end

    it "should contain a host" do
      expect(subject['host']).to be == host
    end

    it "should contain a port" do
      expect(subject['port']).to be == port
    end

    it "should contain a path" do
      expect(subject['path']).to be == path
    end

    it "should contain a query" do
      expect(subject['query']).to be == query
    end
  end

  describe "#to_s" do
    it "should return the full link" do
      expect(subject.to_s).to be == url.to_s
    end
  end
end
