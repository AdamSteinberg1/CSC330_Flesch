#!/bin/bash
printf "%-20s%-20s%-20s%-20s%-20s\n" "Language" "Translation" "Flesch" "Flesch-Kinicaid" "Dale-Chall"

translations=$(ls /pub/pounds/CSC330/translations/)

cd cpp
g++ flesch.cpp
for entry in $translations
do
  data=$(./a.out $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | rev | cut -d' ' -f1 | rev)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kincaid" | rev | cut -d' ' -f1 | rev)
  daleChall=$(echo "$data" | grep "Dale-Chall" | rev | cut -d' ' -f1 | rev)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "C++" $entry $flesch $fleschKincaid $daleChall
done
rm a.out
cd ..

cd java
javac flesch.java
for entry in $translations
do
  data=$(java flesch $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | rev | cut -d' ' -f1 | rev)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kincaid" | rev | cut -d' ' -f1 | rev)
  daleChall=$(echo "$data" | grep "Dale-Chall" | rev | cut -d' ' -f1 | rev)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Java" $entry $flesch $fleschKincaid $daleChall
done
rm flesch.class
cd ..

cd fortran
gfortran flesch.f95
for entry in $translations
do
  data=$(./a.out $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | rev | cut -d' ' -f1 | rev)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | rev | cut -d' ' -f1 | rev)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kincaid" | rev | cut -d' ' -f1 | rev)
  daleChall=$(echo "$data" | grep "Dale-Chall" | rev | cut -d' ' -f1 | rev)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Fortran" $entry $flesch $fleschKincaid $daleChall
done
rm a.out
cd ..

cd python
for entry in $translations
do
  data=$(./flesch.py $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | rev | cut -d' ' -f1 | rev)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kincaid" | rev | cut -d' ' -f1 | rev)
  daleChall=$(echo "$data" | grep "Dale-Chall" | rev | cut -d' ' -f1 | rev)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Python" $entry $flesch $fleschKincaid $daleChall
done
cd ..

cd perl
for entry in $translations
do
  data=$(./flesch.pl $entry)
  flesch=$(echo "$data" | grep "Flesch Readability Index" | cut -d' ' -f5)
  fleschKincaid=$(echo "$data" | grep "Flesch-Kincaid" | cut -d' ' -f6)
  daleChall=$(echo "$data" | grep "Dale-Chall" | cut -d' ' -f5)
  printf "%-20s%-20s%-20s%-20s%-20s\n" "Perl" $entry $flesch $fleschKincaid $daleChall
done
cd ..
