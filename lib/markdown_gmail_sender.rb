#!/usr/bin/env ruby

# file: markdown_gmail_sender.rb

require 'gmail'
require 'rdiscount'
require 'fileutils'


class MarkdownGmailSender

  def initialize(accounts={}, compose_dir: '~/email/compose',
       sent_dir: '~/email/sent')

    @accounts = accounts

    compose_dirpath = File.expand_path(compose_dir)
    @sent_dir = File.expand_path(sent_dir)
    FileUtils.mkdir_p @sent_dir

    # scan the compose directory for email files to deliver

    @messages = Dir.glob(File.join(compose_dirpath, '*.md')).map do |filepath|

      s = File.read filepath

      /from: (?<from>[\S]+)/ =~ s; /to: (?<to>[\S]+)/ =~ s
      /subject: (?<subject>[^\n]+)\n(?<body>.*)/m =~ s

      {
        filepath: filepath, from: from, to: to, subject: subject, 
        body_txt: body, body_html: RDiscount.new(body).to_html
      }

    end

  end

  def deliver_all()

    @messages.each.with_index do |x, i|

      gmail = Gmail.new(username=x[:from], password=@accounts[x[:from]])
      
      if not gmail.signed_in? then
        raise "markdown_gmail_sender: Gmail user #{username} not signed in"
      end
      
      gmail.deliver do

        to x[:to]; subject x[:subject]

        text_part { body x[:body_txt] }

        html_part do
          content_type 'text/html; charset=UTF-8'
          body x[:body_html]
        end

      end

      target = Time.now.strftime("m%d%m%yT%H%Ma")
      target.succ! while File.exists? target
      
      FileUtils.mv x[:filepath], File.join(@sent_dir, target + '.md')
      
      puts "message #{(i+1).to_s} sent" 
      
    end

  end

  alias deliver deliver_all
  
end