[![Code Climate](https://codeclimate.com/github/trailofbits/tacklebox/badges/gpa.svg)](https://codeclimate.com/github/trailofbits/tacklebox) [![Test Coverage](https://codeclimate.com/github/trailofbits/tacklebox/badges/coverage.svg)](https://codeclimate.com/github/trailofbits/tacklebox) [![Build Status](https://travis-ci.org/trailofbits/tacklebox.svg)](https://travis-ci.org/trailofbits/tacklebox)

# tacklebox

* [Homepage](https://github.com/trailofbits/tackle_box)
* [Documentation](http://rubydoc.info/gems/tackle_box/frames)

## Description

A phishing toolkit for generating and sending phishing emails.

## Features

* Provides a [Liquid][liquid] + Markdown email template system.
* Provides built-in [liquid] tags for customized emails:
  * {TackleBox::Email::Template::Tags::Attachment attachment}
  * {TackleBox::Email::Template::Tags::Date date}
  * {TackleBox::Email::Template::Tags::Day day}
  * {TackleBox::Email::Template::Tags::Link link}
  * {TackleBox::Email::Template::Tags::RandomDate random_date}
  * {TackleBox::Email::Template::Tags::RandomDay random_day}
  * {TackleBox::Email::Template::Tags::RandomGreeting random_greeting}
  * {TackleBox::Email::Template::Tags::RandomWeekDay random_week_day}
  * {TackleBox::Email::Template::Tags::WeekDay week_day}
  * {TackleBox::Email::Template::Tags::Year year}
* Renders dynamic emails based on the recipient.
* Supports targeting specific sub-groups of people within an organization.
* Supports embedding links and/or attachments into emails.
* Supports custom 1x1 tracking pixel URLs.

## API

* {TackleBox::Attachment}
* {TackleBox::Link}
* {TackleBox::Person}
* {TackleBox::Organization}
* {TackleBox::Campaign}
  * {TackleBox::Campaign#initialize}
  * {TackleBox::Campaign#each_email}

## Examples

    require 'tackle_box'

    email_template = TackleBox::Email::Template.open('nude_pics.eml')

    org = TackleBox::Organization.new(
      'Trail of Bits, Inc.',

      domain:   'trailofbits.com',
      website:  'http://www.trailofbits.com/',
      industry: 'Technology'
    )
    org.person('dan@trailofbits.com', name:       'Dan Guido',
                                      title:      'CEO',
                                      department: 'Management',
                                      location:   'New York, NY')

    campaign = TackleBox::Campaign.new(
      email_template, org,

      link: 'http://www.imdurr.com/gallery/x5ae18.png',
      tracking_pixel: 'http://www.imdurr.com/pixel.gif',
      account: TackleBox::Person.new(
        'nick.d@yelpfortoilets.com',
        name:  'Nick Depetrillo',
        title: 'CTO'
      )
    )

    sender = TackleBox::Email::Sender.new(
      'trailofberts.com' => {
        address:              'mail.yelpfortoilets.com',
        port:                 587,
        user_name:            'nick.d',
        password:             'test1234',
        authentication:       :plain,
        enable_starttls_auto: true
      }
    )

    campaign.each_email do |email|
      puts ">>> Sending email to #{email.to}"
      puts email

      sender.send(email)
    end

### Example Email Template

    Date: Tue, 01 Jul 2014 14:21:08 -0700
    Message-ID: <53b32644bd0dd_b221112ff0516b4@tank.lab.mail>
    Subject: Nude pics!
    Mime-Version: 1.0
    Content-Type: text/html;
     charset=ISO-8895-1
    Content-Transfer-Encoding: 7bit
    
    <html>
      <head>
        <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
        <title>test email</title>
      </head>
      <body text="#000000" bgcolor="#FFFFFF">
        Yo {{ to.name }}, checkout these <a href="{% link %}">nudes</a>
        of Brian Krebs!
      </body>
    </html>

## Requirements

* [Ruby] >= 1.9.3
* [activesupport] ~> 3.2
* [shorturl] ~> 1.0
* [liquid] ~> 2.4
* [nokogiri] ~> 1.6
* [chars] ~> 0.2
* [mail] ~> 2.5

## Install

    $ bundle install

## Testing

    $ rake spec

## Documentation

    $ rake yard
    $ open ./doc/index.html

## Copyright

Copyright (c) 2014 Trail of Bits, Inc.

[Ruby]: http://www.ruby-lang.org/
[activesupport]: https://github.com/rails/rails/tree/master/activesupport#readme
[shorturl]: https://github.com/robbyrussell/shorturl#readme
[liquid]: http://liquidmarkup.org/
[nokogiri]: http://nokogiri.org/
[chars]: https://github.com/postmodern/chars#readme
[mail]: https://github.com/mikel/mail
