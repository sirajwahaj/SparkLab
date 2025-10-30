FROM openjdk:17-slim

# Install dependencies
RUN apt-get update && apt-get install -y wget python3 python3-pip bash && rm -rf /var/lib/apt/lists/*

# Set Spark version
ENV SPARK_VERSION=4.0.0
ENV SPARK_HOME=/opt/spark
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Download and install Spark
RUN wget -q https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 $SPARK_HOME \
    && rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Install Jupyter and findspark
RUN pip install jupyter notebook findspark

# Expose Spark + Jupyter ports
EXPOSE 7077 8080 8081 8888

# Default command
CMD if [ "$SPARK_MODE" = "master" ]; then \
    $SPARK_HOME/sbin/start-master.sh && \
    jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root; \
    else \
    $SPARK_HOME/sbin/start-worker.sh $SPARK_MASTER_URL && \
    tail -f $SPARK_HOME/logs/*; \
    fi
