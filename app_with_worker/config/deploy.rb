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
    on roles(:all), in: :parallel do |host|
      upload! "config/#{host.fetch(:service)}.service", "/tmp/#{host.fetch(:service)}.service"
      sudo "cp /tmp/#{host.fetch(:service)}.service /etc/systemd/system/#{host.fetch(:service)}.service"
      sudo "systemctl enable #{host.fetch(:service)}"
      sudo "systemctl daemon-reload"
    end
  end

  desc 'systemctl start'
  task :start do
    on roles(:all), in: :parallel do |host|
      sudo "systemctl start #{host.fetch(:service)}"
    end
  end

  desc 'systemctl stop'
  task :stop do
    on roles(:all), in: :parallel do |host|
      sudo "systemctl stop #{host.fetch(:service)}"
    end
  end

  desc 'systemctl restart'
  task :restart do
    on roles(:all), in: :parallel do |host|
      sudo "systemctl restart #{host.fetch(:service)}"
    end
  end
end
