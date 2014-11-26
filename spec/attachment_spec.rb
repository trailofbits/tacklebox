require 'spec_helper'
require 'tackle_box/attachment'

describe TackleBox::Attachment do
  describe "#initialize" do
    context "when neither :path or :content are given" do
      it "should raise an ArgumentError" do
        expect {
          described_class.new
        }.to raise_error(ArgumentError,"must specify :path or :content")
      end
    end

    context "when :path is given" do
      let(:path) { __FILE__ }

      subject { described_class.new(path: path) }

      it "should set the path" do
        expect(subject.path).to be path
      end

      context "when :name is also given" do
        let(:name) { "nudes.zip" }

        subject { described_class.new(path: path, name: name) }

        it "should override the default :name" do
          expect(subject.name).to be name
        end
      end

      context "when :name is not given" do
        it "should derive the name from the path" do
          expect(subject.name).to be == File.basename(path)
        end
      end

      context "when :content is not given" do
        it "should default to the files contents" do
          expect(subject.content).to be == File.binread(path)
        end
      end
    end

    context "when :content is given" do
      context "when :name is not given" do
        it "should raise an ArgumentError" do
          expect {
            described_class.new(content: "foo")
          }.to raise_error(ArgumentError,":path or :name are required")
        end
      end

      context "when :name is given" do
        let(:name)    { "nudes.zip" }
        let(:content) { "foo bar"   }

        subject { described_class.new(name: name, content: content) }

        it "should set content and name" do
          expect(subject.name).to be name
          expect(subject.content).to be content
        end
      end
    end

    context "when :encoding is not given" do
      let(:name)     { 'nudes.zip' }
      let(:content)  { "foo bar"   }
      let(:encoding) { 'zip'       }

      subject { described_class.new(name: name, content: content) }

      it "should derive the encoding from the attachment name" do
        expect(subject.encoding).to be == encoding
      end
    end
  end

  describe "#to_liquid" do
    let(:name)     { 'nudes.zip' }
    let(:encoding) { 'zip'       }
    let(:password) { "infected"  }

    subject do
      described_class.new(
        name:     name,
        content:  double,
        encoding: encoding,
        password: password
      ).to_liquid
    end

    it "should contain the name" do
      expect(subject['name']).to be name
    end

    it "should contain the encoding" do
      expect(subject['encoding']).to be encoding
    end

    it "should contain the password" do
      expect(subject['password']).to be password
    end
  end
end
