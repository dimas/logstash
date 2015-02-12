def run_rspec(*args)
  require "logstash/environment"
  LogStash::Environment.set_gem_paths!
  require "rspec/core/runner"
  require "rspec"
  RSpec::Core::Runner.run([*args])
end

namespace "test" do
  task "core" do
    run_rspec(Rake::FileList["spec/**/*.rb"])
  end

  task "core-fail-fast" do
    run_rspec("--fail-fast", Rake::FileList["spec/**/*.rb"])
  end

  task "plugins" do
    run_rspec("--order", "rand", Rake::FileList[File.join(ENV["GEM_HOME"], "gems/logstash-*/spec/{input,filter,codec,output}s/*_spec.rb")])
  end

  task "install-core" => ["bootstrap", "plugin:install-core", "plugin:install-development-dependencies"]

  task "install-default" => ["bootstrap", "plugin:install-default", "plugin:install-development-dependencies"]

  task "install-all" => ["bootstrap", "plugin:install-all", "plugin:install-development-dependencies"]
end

task "test" => [ "test:core" ]
