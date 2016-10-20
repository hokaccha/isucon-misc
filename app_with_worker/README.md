### development

server:

```
$ bundle exec unicorn
```

worker:

```
$ bundle exec sidekiq -C sidekiq.yml
```

### deploy

```
$ bundle exec cap production systemctl:setup
$ bundle exec cap production deploy
```

### log

```
$ journalctl -u unicorn -f
$ journalctl -u sidekiq -f
```
