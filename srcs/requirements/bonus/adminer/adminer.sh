#!/bin/sh

mkdir -p /var/www/html/

wget https://www.adminer.org/latest.php -O /var/www/html/adminer.php

chown www-data:www-data /var/www/html/adminer.php

chmod 755 /var/www/html/adminer.php

mv /var/www/html/adminer.php /var/www/html/index.php

php -S  0.0.0.0:8088 -t /var/www/html