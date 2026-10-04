# AXON One Pro — landing page (static, single file)
# Build: none needed. Serve index with nginx.
FROM nginx:1.27-alpine

RUN rm -f /usr/share/nginx/html/index.html
COPY axon-one-pro-landing.html /usr/share/nginx/html/index.html

# gzip on so the ~1 file ships fast
RUN printf 'server {\n\
  listen 8080;\n\
  server_name _;\n\
  root /usr/share/nginx/html;\n\
  index index.html;\n\
  gzip on;\n\
  gzip_types text/html text/css application/javascript image/svg+xml;\n\
  gzip_min_length 1024;\n\
  add_header Cache-Control "no-cache";\n\
  location / { try_files $uri $uri/ /index.html; }\n\
}\n' > /etc/nginx/conf.d/default.conf

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://127.0.0.1:8080/ || exit 1
