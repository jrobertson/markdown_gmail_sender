# Introducing the markdown_gmail_sender gem

    require 'markdown_gmail_sender'

    mgs = MarkdownGmailSender.new({'your_username@gmail.com' => 'yourpassword'}, 
               compose_dir: '/tmp/email/compose', sent_dir: '/tmp/email/sent')
    mgs.deliver_all

The markdown_gmail_sender gem scans the compose directory for markdown files which contain email messages to be sent. Once an email has been sent, it's file is moved from the compose directory to the sent directory.

Here's a sample markdown file (/tmp/email/test1.md):

<pre>
from: your_username@gmail.com
to: james@*********.co.uk

subject: Another test message

Hi, this is just a test message to see if it will actually send a message in **HTML format** as well as plain text.

Hope it works!

Happy testing,

James
</pre>

Note: The markdown file must contain the following fields: *from*, *to* and *subject*.


## Resources

* Sending an email using the Gmail gem http://www.jamesrobertson.eu/snippets/2016/may/30/sending-an-email-using-the-gmail-gem.html
* markdown_gmail_sender https://rubygems.org/gems/markdown_gmail_sender

gmail markdown send email gem
