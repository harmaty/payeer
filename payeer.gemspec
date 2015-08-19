Gem::Specification.new do |s|
  s.name        = 'payeer'
  s.version     = '0.0.1'
  s.date        = '2015-08-20'
  s.summary     = "Payeer client"
  s.description = "Ruby wrapper for Payeer API"
  s.authors     = ["Artem Harmaty"]
  s.email       = 'harmaty@gmail.com'
  s.files       = Dir["{lib}/**/*"]
  s.homepage    = 'https://github.com/harmaty/payeer'
  s.add_dependency 'activesupport', '>= 3.0.0'
  s.license = 'MIT'
end