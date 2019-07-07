#!/bin/bash
echo "!!!!!!!! Check Elasticsearch for available !!!!!!!!"

until curl http://"elasticsearch":"9200"; do
    echo "Elasticsearch is unavailable - sleeping"
    sleep 30
done

echo "Elasticsearch is up - executing command"

/opt/apache-atlas-2.0.0/bin/atlas_start.py
tail -f /dev/null 
