Gem::Specification.new do |s|
  s.name = 'markdown_gmail_sender'
  s.version = '0.1.2'
  s.summary = 'Scans a *compose* folder (file directory) for messages (files in markdown format) to send using the gmail gem.'
  s.authors = ['James Robertson']
  s.files = Dir['lib/markdown_gmail_sender.rb']
  s.add_runtime_dependency('gmail', '~> 0.6', '>=0.6.0')
  s.add_runtime_dependency('rdiscount', '~> 2.2', '>=2.2.0.1')
  s.signing_key = '../privatekeys/markdown_gmail_sender.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/markdown_gmail_sender'
end
