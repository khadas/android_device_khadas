#!/bin/bash


if [ ! -x "$(pwd)/device/khadas/common/PQCompress/miniz_test" ]; then
    chmod +x $(pwd)/device/khadas/common/PQCompress/miniz_test
fi

for db in $(find $1 -name *.db)
do
    echo $db
    path=${db%.db}
    echo $path

    overscan_db=${path##*/}
    if [ $overscan_db != "overscan" ]; then
        $(pwd)/device/khadas/common/PQCompress/miniz_test $path.bin $db
        #rm $db
    fi
done
