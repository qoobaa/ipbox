class Scheduled::BackupJob
  include Sidekiq::Worker

  def perform
    command = <<-EOC
      bundle exec backup perform -t production \\
        --config-file #{Rails.root.join('backup', 'config.rb')} \\
        --data-path #{Rails.root.join('backup', 'data')} \\
        --tmp-path #{Rails.root.join('tmp', 'backup')} \\
        --log-path #{Rails.root.join('log')}
    EOC

    system(command, exception: true)
  end
end


