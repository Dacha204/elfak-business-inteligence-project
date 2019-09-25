#!/bin/bash

set -e -o pipefail

echo "Cleaning index"
curl -XDELETE localhost:9200/measurements

echo "Create index"
curl -XPUT localhost:9200/measurements -H "Content-Type: application/json" -d @measurments_index.json

echo "Insert data"
mkdir -p output
MAINDIR=`pwd`
cd output

echo "Preparing bulk files..."
awk '{ printf("{\"index\":{\"_id\":%d}}\n%s\n", NR, $0)}' ${MAINDIR}/index_docs.json | split -l 10000 --numeric-suffixes - bulk_

for f in bulk_* ; do
  echo "Processing $f bulk file ..."
  curl -XPOST localhost:9200/measurements/_bulk -H "Content-Type: application/x-ndjson" --data-binary @$f
done

echo "Completed"
