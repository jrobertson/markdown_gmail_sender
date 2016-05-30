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

      from = s[/from: ([\S]+)/,1]
      to = s[/to: ([\S]+)/,1]
      subject = s[/subject: ([^\n]+)/,1]
      subject_line  = s.lines.detect{|x|  x =~ /subject: / }
      body = s.lines[(s.lines.index(subject_line) + 1) .. -1].join.strip

      {
        filepath: filepath, 
        from: from, to: to, 
        subject: subject, 
        body_txt: body, body_html: RDiscount.new(body).to_html
      }

    end

  end

  def deliver_all()

    @messages.each.with_index do |x, i|

      username, password = x[:from], @accounts[x[:from]]
      gmail = Gmail.new(username, password)

      gmail.deliver do

        to x[:to]
        subject x[:subject]

        text_part do
          body x[:body_txt]
        end

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
