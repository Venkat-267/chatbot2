# Use the official Nginx image as base
FROM nginx:latest

# Remove default Nginx index page and copy your HTML file
COPY mainpage.html /usr/share/nginx/html/index.html

# Expose port 80 to allow external access
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
