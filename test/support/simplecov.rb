if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter %r{^/(?!app|lib)/}
    add_filter %r{^/app/channels/}
    add_filter %r{^/lib/populators/}
    add_filter 'app/channels/application_cable'
    add_filter 'app/jobs/application_job.rb'
    add_filter 'app/mailers/application_mailer.rb'
    add_filter 'app/models/application_record.rb'
  end
end
