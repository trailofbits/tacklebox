require 'spec_helper'

require 'tackle_box/email/template/tags/random_greeting'

describe TackleBox::Email::Template::Tags::RandomGreeting do
  subject { Liquid::Template.parse('{% random_greeting %}') }

  it "should add a random greeting" do
    expect(subject.render).not_to be_empty
  end
end
