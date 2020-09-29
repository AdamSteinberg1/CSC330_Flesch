#!/bin/bash
#test
printf "%-20s%-20s%-20s%-20s%-20s\n" "Language" "Translation" "Flesch" "Flesch-Kinicaid" "Dale-Chall"


g++ cpp/flesch.cpp
for entry in `ls /pub/pounds/CSC330/translations/`
do
  data=$(./a.out $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | cut --delimiter=" " -f5)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kinchaid" | cut --delimiter=" " -f6)
  daleChall=$(echo "$data" | grep "Dale-Chall" | cut --delimiter=" " -f5)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "C++" $entry $flesch $fleschKincaid $daleChall
done
rm a.out

cd java
javac flesch.java
for entry in `ls /pub/pounds/CSC330/translations/`
do
  data=$(java flesch $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | cut --delimiter=" " -f5)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kinchaid" | cut --delimiter=" " -f6)
  daleChall=$(echo "$data" | grep "Dale-Chall" | cut --delimiter=" " -f5)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Java" $entry $flesch $fleschKincaid $daleChall
done
rm flesch.class
cd ..

gfortran fortran/flesch.f95
for entry in `ls /pub/pounds/CSC330/translations/`
do
  data=$(./a.out $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | cut --delimiter=" " -f5)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kinchaid" | cut --delimiter=" " -f6)
  daleChall=$(echo "$data" | grep "Dale-Chall" | cut --delimiter=" " -f5)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Fortran" $entry $flesch $fleschKincaid $daleChall
done
rm a.out


for entry in `ls /pub/pounds/CSC330/translations/`
do
  data=$(./python/flesch.py $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | cut --delimiter=" " -f5)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kinchaid" | cut --delimiter=" " -f6)
  daleChall=$(echo "$data" | grep "Dale-Chall" | cut --delimiter=" " -f5)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Python" $entry $flesch $fleschKincaid $daleChall
done

for entry in `ls /pub/pounds/CSC330/translations/`
do
  data=$(./perl/flesch.pl $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | cut --delimiter=" " -f5)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kinchaid" | cut --delimiter=" " -f6)
  daleChall=$(echo "$data" | grep "Dale-Chall" | cut --delimiter=" " -f5)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Perl" $entry $flesch $fleschKincaid $daleChall
done
