#!/bin/bash -e

for data_set in original/*.csv ; do
	echo "Processing $data_set"
	head -n 4000 $data_set > ../`basename $data_set`
done

echo "Completed."
