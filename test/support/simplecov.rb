if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    skip %r{^/(?!app|lib)/}
    skip %r{^/app/channels/}
    skip %r{^/lib/populators/}
    skip 'app/channels/application_cable'
    skip 'app/jobs/application_job.rb'
    skip 'app/mailers/application_mailer.rb'
    skip 'app/models/application_record.rb'
  end
end
