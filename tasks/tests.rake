desc "Run all tests"
Spec::Rake::SpecTask.new('test:unit') do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', '/var/lib/gems']
  t.spec_files = FileList['test/unit/*_spec.rb']
end
