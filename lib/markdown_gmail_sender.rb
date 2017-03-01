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

    @messages = Dir.glob(File.join(compose_dirpath, '*.md')).map do |mdfile|

      s = File.read mdfile

      
      regex = %r{

        (?<email>(?:.*<)?[^@]+@\S+>?){0}
        (?<filepath>\s*[\w\/\.\-]+\s+){0}

        from:\s(?<from>\g<email>)\s+
        to:\s(?<to>\g<email>)\s+
        (?:attachments?:\s+(?<attachments>\g<filepath>*))?
        subject:\s+(?<subject> [^\n]+)\n
        (?<body> .*)

      }xm
      
      r = regex.match(s)
      
      files = r[:attachments].nil? ? [] : r[:attachments].split.map(&:strip)

      {
        filepath: mdfile, from: r[:from], to: r[:to], 
        attachments: files, subject: r[:subject], body_txt: r[:body], 
        body_html: RDiscount.new(r[:body]).to_html
      }

    end

  end

  def deliver_all()

    @messages.each.with_index do |x, i|

      from = x[:from][/(?:.*<)?(\w+(?:\.\w+)?@\S+[^>])/,1]

      username, password = from, @accounts[from]

      gmail = Gmail.new(username, password)
      
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
        
        x[:attachments].each do |attachment|
          add_file attachment.strip
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