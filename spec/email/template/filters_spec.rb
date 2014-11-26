require 'spec_helper'

require 'tackle_box/email/template/filters'

describe TackleBox::Email::Template::Filters do
  describe "lowercase" do
    subject { Liquid::Template.parse('{{ "INPUT" | lowercase }}') }

    it "should downcase the input" do
      expect(subject.render).to eq('input')
    end
  end

  describe "uppercase" do
    subject { Liquid::Template.parse('{{ "input" | uppercase }}') }

    it "should upcase the input" do
      expect(subject.render).to eq('INPUT')
    end
  end

  describe "capitalize" do
    subject { Liquid::Template.parse('{{ "input" | capitalize }}') }

    it "should capitalize the input" do
      expect(subject.render).to eq('Input')
    end
  end

  describe "pluralize" do
    subject { Liquid::Template.parse('{{ "input" | pluralize }}') }

    it "should pluralize the input" do
      expect(subject.render).to eq('inputs')
    end
  end

  describe "singularize" do
    subject { Liquid::Template.parse('{{ "inputs" | singularize }}') }

    it "should singularize the input" do
      expect(subject.render).to eq('input')
    end
  end
end
