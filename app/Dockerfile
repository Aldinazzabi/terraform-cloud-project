FROM nginx:1.27-alpine

COPY index.html /usr/share/nginx/html/index.html

# Simple health check
RUN echo "OK" > /usr/share/nginx/html/health

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]