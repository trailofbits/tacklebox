require 'spec_helper'

require 'tackle_box/email/template/tags/day'

describe TackleBox::Email::Template::Tags::Day do
  subject { Liquid::Template.parse('{% day %}') }

  it "should render the current day" do
    expect(subject.render).to eq("#{Date.today.day}")
  end
end
