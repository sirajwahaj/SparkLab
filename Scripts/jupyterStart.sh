#!/bin/bash
set -e

echo "🚀 Starting Spark Master + Jupyter + History Server..."

# Ensure spark-events exists
mkdir -p /tmp/spark-events

# Start Jupyter Notebook (background) without token
jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token='' &

# Start Spark History Server
"$SPARK_HOME"/sbin/start-history-server.sh

# Tail Spark logs (not directories!)
tail -f "$SPARK_HOME"/logs/*.out
