require 'spec_helper'
require 'tackle_box/email/template/tags/week_day'

describe TackleBox::Email::Template::Tags::WeekDay do
  subject { Liquid::Template.parse('{% week_day %}') }

  let(:week_days) { %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday] }

  it "should render the current week day" do
    expect(subject.render).to eq(week_days[Date.today.wday])
  end
end
