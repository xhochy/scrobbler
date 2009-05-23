desc "Run all tests"
Spec::Rake::SpecTask.new('test:unit') do |t|
  t.spec_files = FileList['test/unit/*_spec.rb']
end
