Gem::Specification.new do |s|
  s.name = 'markdown_gmail_sender'
  s.version = '0.2.1'
  s.summary = 'Scans a *compose* folder (file directory) for messages (files in markdown format) to send using the gmail gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/markdown_gmail_sender.rb']
  s.add_runtime_dependency('gmail', '~> 0.6', '>=0.6.0')
  s.add_runtime_dependency('martile', '~> 0.6', '>=0.6.37')
  s.add_runtime_dependency('kramdown', '~> 1.13', '>=1.13.2')
  s.signing_key = '../privatekeys/markdown_gmail_sender.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/markdown_gmail_sender'
end
