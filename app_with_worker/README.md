### development

server:

```
$ bundle exec ruby app.rb
```

worker:

```
$ bundle exec sidekiq -C sidekiq.yml
```

### deploy

```
$ sudo cp sidekiq.service /lib/systemd/system/sidekiq.service
$ sudo systemctl enable sidekiq
$ sudo systemctl start sidekiq
```

show log:

```
$ journalctl -u sidekiq -f
```
