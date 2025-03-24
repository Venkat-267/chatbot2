FROM nginx:latest

# Copy all website files (including subpages) to the Nginx HTML directory
COPY . /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
