require 'rubygems'
require 'rake/gempackagetask'
require 'rake/testtask'

require 'lib/sluggable/version'

spec = Gem::Specification.new do |s|
  s.name             = 'sluggable'
  s.version          = Sluggable::Version.to_s
  s.has_rdoc         = true
  s.extra_rdoc_files = %w(README.rdoc)
  s.rdoc_options     = %w(--main README.rdoc)
  s.summary          = "This gem provides an easy way to create slugs for your ActiveRecord models"
  s.author           = 'Patrick Reagan'
  s.email            = 'reaganpr@gmail.com'
  s.homepage         = 'http://sneaq.net'
  s.files            = %w(README.rdoc Rakefile) + Dir.glob("{lib,test}/**/*")
  
  s.add_dependency('activesupport', '>= 2.1.1')
  s.add_dependency('activerecord', '>= 2.1.1')
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

namespace :db do
  desc 'Create the test database'
  task :create do
    require 'activerecord'
    require 'test/support/configuration'

    path = File.dirname(__FILE__) + '/test/support'

    ActiveRecord::Base.establish_connection(Configuration.database(path))
    ActiveRecord::Base.connection

    load(File.dirname(__FILE__) + '/test/support/database.rb')
  end

  task :drop do
    Dir[File.dirname(__FILE__) + '/test/support/*.sqlite3'].each {|f| FileUtils.rm(f) }
  end
  
  task :reset => [:drop, :create]
end

Rake::TestTask.new(:test => 'db:reset') do |t|
  t.libs << 'test'
  t.test_files = FileList["test/**/*_test.rb"]
  t.verbose = true
end

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new(:coverage => 'db:reset') do |t|
    t.libs       = ['test']
    t.test_files = FileList["test/**/*_test.rb"]
    t.verbose    = true
    t.rcov_opts  = ['--text-report', "-x #{Gem.path}", '-x /Library/Ruby', '-x /usr/lib/ruby']
  end
  
  task :default => :coverage
  
rescue LoadError
  warn "\n**** Install rcov (sudo gem install relevance-rcov) to get coverage stats ****\n"
  task :default => :test
end

desc 'Generate the gemspec for the Gem (useful when serving from Github)'
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, 'w') {|f| f << spec.to_ruby }
  puts "Created gemspec: #{file}"
end

task :github => :gemspec