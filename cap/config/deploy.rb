lock '3.6.1'

set :application, 'isucon'
set :repo_url, 'git@github.com:hokaccha/isucon-misc.git'
set :deploy_to, '/home/ubuntu/app'

set :bundle_gemfile, -> { release_path.join('cap', 'Gemfile') }

namespace :systemd do
  desc 'Setup systemd'
  task :setup do
    on roles(:app), in: :parallel do |host|
      upload! 'config/unicorn.service', '/tmp/unicorn.service'
      sudo 'cp /tmp/unicorn.service /etc/systemd/system/unicorn.service'
      sudo 'systemctl enable unicorn'
      sudo 'systemctl daemon-reload'
    end

    # on roles(:worker), in: :parallel do |host|
    #   uptime = capture(:uptime)
    #   puts "#{host.hostname} reports: #{uptime}"
    # end
  end

  desc 'systemctl start'
  task :start do
    on roles(:app), in: :parallel do |host|
      sudo 'systemctl start unicorn'
    end
  end

  desc 'systemctl stop'
  task :stop do
    on roles(:app), in: :parallel do |host|
      sudo 'systemctl stop unicorn'
    end
  end

  desc 'systemctl restart'
  task :restart do
    on roles(:app), in: :parallel do |host|
      sudo 'systemctl restart unicorn'
    end
  end
end
