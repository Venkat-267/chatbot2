# Use Nginx as a base image
FROM nginx:latest

# Remove default Nginx config
RUN rm /etc/nginx/conf.d/default.conf

# Copy your custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/

# Copy your frontend files (HTML, CSS, JS) to the web root
COPY . /usr/share/nginx/html

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
