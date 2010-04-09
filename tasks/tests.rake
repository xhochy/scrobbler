desc "Run all tests"
Spec::Rake::SpecTask.new('test:unit') do |t|
  begin
    require 'rcov'
    t.rcov = true
    t.rcov_opts = ['--exclude', '/var/lib/gems']
  rescue LoadError
    t.rcov = false
  end
  t.spec_opts << '--format' << 'html:spec.html'
  t.spec_opts << '--format' << 'progress'
  t.spec_opts << '-b'
  t.spec_files = FileList['test/unit/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'test/unit/*_spec.rb'
  spec.rcov = true
end

