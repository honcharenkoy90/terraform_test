#!/bin/bash
yum -y update
yum -y install nginx

rm /usr/share/nginx/html/index.html

cat <<FILE > /usr/share/nginx/html/index.html
<!DOCTYPE html PUBLIC>
 <html>
 <body>

 <h1>My First Heading</h1>
 <p>My first paragraph.</p>

 </body>
</html>
FILE

service nginx restart