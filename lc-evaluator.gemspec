Gem::Specification.new do |s|
  s.name        = 'lc-evaluator'
  s.version     = '0.1.0'
  s.summary     = 'Simple lambda calculus parser and evaluator'
  s.authors     = ['Filip Gregor']
  s.email       = 'gregofi1@fit.cvut.cz'
  s.files       = Dir['lib/**/*', '*.gemspec', 'README*']
  s.executables = Dir['bin/*'].map { |f| File.basename(f) }
end
