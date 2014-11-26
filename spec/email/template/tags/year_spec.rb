require 'spec_helper'

require 'tackle_box/email/template/tags/year'

describe TackleBox::Email::Template::Tags::Year do
  subject { Liquid::Template.parse('{% year %}') }

  it "should render the current year" do
    expect(subject.render).to eq("#{Date.today.year}")
  end
end
