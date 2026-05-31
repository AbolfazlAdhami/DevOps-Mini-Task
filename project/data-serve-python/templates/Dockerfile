FROM python:3.11-alpine

 
WORKDIR /data

 
EXPOSE {{ server_port }}

 
CMD ["python3", "-m", "http.server", "{{ server_port }}"]