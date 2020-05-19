# HTML Maintenance Page

We needed a simple HTTP 503 status page to let visitors know that the server is currently under maintenance.

Using a very basic python3 http.server we are able to redirect the external Nginx proxy to this simple web server.

## Usage

Optionally mount a folder into the `/var/www/html` folder to use your own static html pages - (html, css, images and JavaScript only).

Sample [docker-compose.yml](docker-compose.yml) included

## nginx.conf snippets

Using the snippets from the `nginx.conf` we are able to turn maintenance on by changing the `geo {}` section value of default to `on`.

This gives a proper 503 temporarily unavailable response to visitors, ensuring that search engines and robots do not get confused by a normal 200 response.

However visitors from the IP address subnets listed will not get passed to the maintenance server. We need to ensure that some systems can continue testing the real service and that some necessary connections like payment gateways are still able to function. Include all the addresses required in the `geo {}` section and specify that maintenance if `off`.

The rewrite in the `@maintenance` location ensures that all requests are redirected to the index page `/`.

```config
geo $maintenance {
    default off;
    192.168.0.0/24 off;
    10.0.1.0/24 off;
}

upstream maintenance {
    server localhost:8080
}

server {
    listen 443 ssl;
...

    if ($maintenance = on) {
        return 503;
    }

    error_page 503 @maintenance;

    location @maintenance {
        rewrite ^(.*)$ / break;
        proxy_pass http://maintenance;
    }
}
```
