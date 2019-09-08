#!/bin/bash -e

for data_set in original/*.csv ; do
	echo "Processing $data_set"
	cat $data_set | grep -v "03-31 02:00" > ../`basename $data_set`
done

echo "Completed."
