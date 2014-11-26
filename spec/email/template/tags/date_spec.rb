require 'spec_helper'

require 'tackle_box/email/template/tags/date'

describe TackleBox::Email::Template::Tags::Date do
  subject { Liquid::Template.parse('{% date %}') }

  it "should render the current date" do
    expect(subject.render).to eq(Date.today.strftime("%b %e"))
  end
end
