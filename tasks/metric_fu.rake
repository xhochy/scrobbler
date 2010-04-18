begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    # Deactivated: saikuro, stats, rcov
    config.metrics  = [:churn, :flog, :flay, :reek, :roodi]
    config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
    config.flay     = { :dirs_to_flay => ['lib'],
                        :minimum_score => 100  } 
    config.flog     = { :dirs_to_flog => ['lib']  }
    config.reek     = { :dirs_to_reek => ['lib']  }
    config.roodi    = { :dirs_to_roodi => ['lib'] }
    config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
    config.rcov     = { :environment => 'test',
                        :test_files => ['test/**/*_test.rb', 
                                        'spec/**/*_spec.rb'],
                        :rcov_opts => ["--sort coverage", 
                                       "--no-html", 
                                       "--text-coverage",
                                       "--no-color",
                                       "--profile",
                                       "--rails",
                                       "--exclude /gems/,/Library/,spec"]}
    config.graph_engine = :bluff
  end
rescue LoadError
  puts "metric_fu not available. Install it with: gem install metric_fu"
end
