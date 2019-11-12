Gem::Specification.new do |s|
  s.name        = 'simple_host_monitoring'
  s.version     = '1.1.1'
  s.date        = '2020-01-02'
  s.summary     = "THIS GEM IS STILL IN DEVELOPMENT STAGE. Track memory, CPU and disk space of any host."
  s.description = "THIS GEM IS STILL IN DEVELOPMENT STAGE. Find documentation here: https://github.com/leandrosardi/simple_host_monitoring."
  s.authors     = ["Leandro Daniel Sardi"]
  s.email       = 'leandro.sardi@expandedventure.com'
  s.files       = [
    "lib/simple_host_monitoring.rb",
    "lib/basehost.rb",
    "lib/remotehost.rb",
    "lib/localhost.rb",
    "lib/localhosthistory.rb",
    "examples/example01.rb",
  ]
  s.homepage    = 'https://rubygems.org/gems/simple_host_monitoring'
  s.license     = 'MIT'
  s.add_runtime_dependency 'websocket', '~> 1.2.8', '>= 1.2.8'
  s.add_runtime_dependency 'json', '~> 1.8.1', '>= 1.8.1'
  s.add_runtime_dependency 'tiny_tds', '~> 1.0.5', '>= 1.0.5'
  s.add_runtime_dependency 'sequel', '~> 4.28.0', '>= 4.28.0'
  s.add_runtime_dependency 'simple_command_line_parser', '~> 1.1.2', '>= 1.1.2'
  s.add_runtime_dependency 'simple_cloud_logging', '~> 1.1.23', '>= 1.1.23'
end