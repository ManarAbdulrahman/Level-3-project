FROM fluent/fluentd:v0.12-2

# The base image automatically copies fluent.conf and the plugins directory
# inside the resulting image

USER root 
WORKDIR /home/fluent
ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH

RUN apk --no-cache add  build-base ruby-dev && \
       gem install fluent-plugin-elasticsearch fluent-plugin-record-reformer fluent-plugin-kubernetes_metadata_filter fluent-plugin-tail_path && \
    rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem && gem sources -c && \
    apk del build-base ruby-dev
COPY fluent.conf /fluentd/etc
COPY elk.conf /fluentd/etc
EXPOSE 24284
CMD exec fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT

