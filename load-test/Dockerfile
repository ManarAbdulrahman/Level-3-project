FROM python:3.8.6-alpine3.12

# Install locust
RUN pip install --upgrade pip
RUN pip install locust
##RUN pip install pyzmq locustio faker

ADD locustfile.py /config/locustfile.py
ADD runLocust.sh /usr/local/bin/runLocust.sh

ENV LOCUST_FILE /config/locustfile.py

EXPOSE 8089

ENTRYPOINT ["/usr/local/bin/runLocust.sh"]
