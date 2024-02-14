# Use a base image with IBM MQ pre-installed
FROM ibmcom/mq:latest

# Copy MQSC scripts for configuration
COPY ./mq-config.mqsc /etc/mqm/

# Run MQSC script to configure queues and channels
RUN runmqsc < /etc/mqm/mq-config.mqsc

# Expose the necessary ports for MQ
EXPOSE 1414 9443

# Healthcheck to ensure MQ is running
HEALTHCHECK --interval=10s --timeout=5s --start-period=30s \
  CMD echo "DISPLAY QSTATUS(ANY)" | runmqsc || exit 1

# Start IBM MQ in background mode
CMD ["runmqdevserver", "-n"]
