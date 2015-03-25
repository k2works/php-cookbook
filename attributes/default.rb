require 'dotenv'

node.default['my-webapp']['common_name'] = 'localhost'
node.default['my-webapp']['docroot'] = "/var/www/html"
node.default['my-webapp']['ssl_cert']['source'] = 'self-signed'
node.default['my-webapp']['ssl_key']['source'] = 'self-signed'

node.default['ne-Api']['client_id'] = 'XXXXXXXXXXXXXX'
node.default['ne-Api']['client_secret'] = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
