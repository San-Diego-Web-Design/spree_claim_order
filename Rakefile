require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/packagetask'
require 'rake/gempackagetask'

spec = eval(File.read('spree_claim_order.gemspec'))

Rake::GemPackageTask.new(spec) do |p|
  p.gem_spec = spec
end

desc "Release to gemcutter"
task :release => :package do
  require 'rake/gemcutter'
  Rake::Gemcutter::Tasks.new(spec).define
  Rake::Task['gem:push'].invoke
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new

#require 'cucumber/rake/task'
#Cucumber::Rake::Task.new do |t|
#  t.cucumber_opts = %w{--format pretty}
#end

desc "Regenerates a rails 3 app for testing"
task :test_app do
  require '../spree/lib/generators/spree/test_app_generator'
  class ClaimOrderTestAppGenerator < Spree::Generators::TestAppGenerator
    def tweak_gemfile
      append_file 'Gemfile' do
<<-gems
        gem 'spree_core', :path => \'#{File.join(File.dirname(__FILE__), "../spree/", "core")}\'
        gem 'spree_auth', :path => \'#{File.join(File.dirname(__FILE__), "../spree/", "auth")}\'
        gem 'spree_claim_order', :path => \'#{File.dirname(__FILE__)}\'
gems
      end
    end

    def install_gems
      inside "test_app" do
        run 'rake spree_core:install'
        run 'rake spree_auth:install'
        run 'rake spree_claim_order:install'
      end
    end

    def migrate_db
      run_migrations
    end
  end
  ClaimOrderTestAppGenerator.start
end

namespace :test_app do
  desc 'Rebuild test and cucumber databases'
  task :rebuild_dbs do
    system("cd spec/test_app && rake db:drop db:migrate RAILS_ENV=test && rake db:drop db:migrate RAILS_ENV=cucumber")
  end
end