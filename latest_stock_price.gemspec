Gem::Specification.new do |spec|
  spec.name          = 'latest_stock_price'
  spec.version       = '0.1.0'
  spec.authors       = ['Hafidz']
  spec.email         = ['hafidz.email@example.com']
  spec.summary       = 'A gem for fetching the latest stock prices.'
  spec.description   = 'A gem that provides a client for interacting with a stock price API.'
  spec.homepage      = 'https://github.com/someusername/latest_stock_price'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'httparty'
end
