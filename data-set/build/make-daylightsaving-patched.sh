#!/bin/bash -e

for data_set in original/*.csv ; do
	echo "Processing $data_set"
	cat $data_set | grep -v "03-31 02:00" | awk -F , '{ print $1","$2","$6","$8","$11","$14","$16","$25","$31 }' | grep -v "2012-" | grep -v "2017-" > ../`basename $data_set`
done

echo "Completed."
