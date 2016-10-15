setting:

```
$ sudo mkdir -p /tmp/nginx/webdav
$ sudo chown www-data:root /tmp/nginx/webdav
$ sudo mkdir -p /var/www/webdav
$ sudo chown www-data:root /var/www/webdav
$ sudo cp nginx.conf /etc/nginx/nginx.conf
$ sudo systemctl restart nginx
```

post request:

```
$ curl -D - -X PUT -d 'Hello wevdav!' http://localhost/files/hello.txt
HTTP/1.1 204 No Content
Server: nginx
Date: Sat, 15 Oct 2016 05:40:30 GMT
Connection: keep-alive
```

get request:

```
$ curl -D - http://localhost/files/hello.txt
HTTP/1.1 200 OK
Server: nginx
Date: Sat, 15 Oct 2016 05:40:41 GMT
Content-Type: text/plain
Content-Length: 13
Last-Modified: Sat, 15 Oct 2016 05:40:30 GMT
Connection: keep-alive
Accept-Ranges: bytes

Hello wevdav!
```
