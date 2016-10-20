lock '3.6.1'

set :application, 'isucon'
set :repo_url, 'git@github.com:hokaccha/isucon-misc.git'
set :deploy_to, '/home/ubuntu/app'
set :app_dir, 'app_with_worker'

set :bundle_gemfile, -> { release_path.join(fetch(:app_dir), 'Gemfile') }

after :deploy, 'systemctl:restart'

namespace :systemctl do
  desc 'Setup systemd'
  task :setup do
    on roles(:app), in: :parallel do |host|
      upload! 'config/unicorn.service', '/tmp/unicorn.service'
      sudo 'cp /tmp/unicorn.service /etc/systemd/system/unicorn.service'
      sudo 'systemctl enable unicorn'
      sudo 'systemctl daemon-reload'
    end

    on roles(:worker), in: :parallel do |host|
      upload! 'config/sidekiq.service', '/tmp/sidekiq.service'
      sudo 'cp /tmp/sidekiq.service /etc/systemd/system/sidekiq.service'
      sudo 'systemctl enable sidekiq'
      sudo 'systemctl daemon-reload'
    end
  end

  desc 'systemctl start'
  task :start do
    on roles(:app), in: :parallel do |host|
      sudo 'systemctl start unicorn'
    end

    on roles(:worker), in: :parallel do |host|
      sudo 'systemctl start sidekiq'
    end
  end

  desc 'systemctl stop'
  task :stop do
    on roles(:app), in: :parallel do |host|
      sudo 'systemctl stop unicorn'
    end

    on roles(:worker), in: :parallel do |host|
      sudo 'systemctl stop sidekiq'
    end
  end

  desc 'systemctl restart'
  task :restart do
    on roles(:app), in: :parallel do |host|
      sudo 'systemctl restart unicorn'
    end

    on roles(:worker), in: :parallel do |host|
      sudo 'systemctl restart sidekiq'
    end
  end
end
