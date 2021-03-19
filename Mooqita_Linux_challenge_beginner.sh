#!/bin/bash

# create temporary files with random suffix
TEMP_FILE=$(mktemp /tmp/mooqita.XXXXXX)
SORTED_FILE=$TEMP_FILE.sorted
CLEARED_FILE=$TEMP_FILE.cleared
# while loop controling size of created file
while [ $(stat -c%s $TEMP_FILE) -lt $((1024*1024)) ]; do
    cat /dev/urandom | tr -dc  [:alnum:] | fold -w 15 | head -n $((1024)) >> $TEMP_FILE
# to speed up process of file creation, the buffer of 15*1024 bytes was used utlizing head command
done
echo The size of generated file \($TEMP_FILE\) is: $(stat -c%s $TEMP_FILE) bytes

# default sorting option was working just fine for this kind of data
sort $TEMP_FILE > $SORTED_FILE
echo The size of generated and sorted file \($SORTED_FILE\) is: $(stat -c%s $SORTED_FILE) bytes

sed '/^[aA].*$/d' $SORTED_FILE > $CLEARED_FILE
echo The size of sorted and cleared file \($CLEARED_FILE\) is: $(stat -c%s $CLEARED_FILE) bytes

LINES_BEFORE=$(wc -l $TEMP_FILE | cut -d ' ' -f1)
LINES_AFTER=$(wc -l $CLEARED_FILE | cut -d ' ' -f1)
echo The clearing process remove $(($LINES_BEFORE-$LINES_AFTER)) lines.
