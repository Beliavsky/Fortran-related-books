#!/usr/bin/bash

# name:    timeline.sh
# author:  nbehrnd@yahoo.com
# license: GPL, v2.
# date:    [2022-06-29 Wed]
# edit:    [2023-03-13 Mon]

# Reverse sort of Beliavsky's compilation of books about Fortran.
#
# The already existing compilation of books about Fortran sorts the entries by
# the family name of the first author of the book in question (alphabetical,
# ascending sequence).  As suggested by one reader, a second version of the list
# were helpful with the entries presented in a geological sort by the date of
# publication (numerical, descending sequence).  The required information is
# provided by the entries in the pattern YYYY.
#
# To work, this bash script depends on
#
# + awk
# + bash
# + cat
# + rm
# + sort
#
# as available e.g., in Linux Debian 12/bookworm (branch testing).  By an input
# of either
#
# bash timeline.sh [filename]
# ./timeline.sh [filename]  # after provision of the executable bit
#
# a new file `Fortran_timeline.md` is written, ready for deposit on GitHub.  If
# present, an earlier version of `Fortran_timeline.md` is going to be replaced.

# report the year of publication identified as leading entry per record
awk -e 'match($0, /[12][0-9]{3}/)  {print \
    substr($0, RSTART, RLENGTH), $0}' "$1" > tmp01

# sort the entries by year of publication (most recent year first)
sort -k 1 -nr tmp01 > tmp02

# group the entries per year of publication
awk 'BEGIN {year=9999}; \
    $1 != year {year = $1; print "##", year"\n"}; \
    $1 == year {gsub(/^[0-9]{4} /, ""); print$0"\n";}' tmp02 > tmp03

# join original header and reorganized timeline
awk 'NR <= 3 {print}' "$1" > Fortran_timeline.md
cat tmp03 >> Fortran_timeline.md

# space cleaning
rm tmp01 tmp02 tmp03
