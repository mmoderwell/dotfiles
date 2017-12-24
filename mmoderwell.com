server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /var/www/portfolio;
    index index.html index.htm;

    # Make site accessible from http://localhost/
    server_name mmoderwell.com;
        

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ /index.html =404;
        # Uncomment to enable naxsi on this location
        # include /etc/nginx/naxsi.rules
    }

	location /api {
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    location  /resume {
        try_files /$uri /$uri.html /resume.html
        index   resume.html;
    }
    location    /contact {
        try_files /$uri /uri.html /contact.html
        index   contact.html;
    }
	location /projects {
		try_files  /$uri /$uri.html /$uri/index.html  /index.html;		
		index	index.html;
	}

	location /blog {
		try_files  /$uri /$uri.html /$uri/index.html  /index.html;
		index	index.html;
	}

    listen 443 ssl; # managed by Certbot
	ssl_certificate /etc/letsencrypt/live/mmoderwell.com/fullchain.pem; # managed by Certbot
	ssl_certificate_key /etc/letsencrypt/live/mmoderwell.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot


    if ($scheme != "https") {
    return 301 https://$host$request_uri;
    } # managed by Certbot

}	

server {
    server_name www.mmoderwell.com;
    return 301 $scheme://mmoderwell.com$request_uri;
}


server {
    server_name sage.mmoderwell.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }

    listen 80; # managed by Certbot

    listen 443 ssl; # managed by Certbot
ssl_certificate /etc/letsencrypt/live/sage.mmoderwell.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/sage.mmoderwell.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


    if ($scheme != "https") {
        return 301 https://$host$request_uri;
    } # managed by Certbot

}
