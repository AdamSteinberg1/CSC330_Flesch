#!/usr/bin/perl
use strict;
use warnings;

# Grab the name of the file from the command line, exit if no name given
my $filename = $ARGV[0] or die "Need to get file name on the  command line\n";

# Use the filename
open(DATA, "/pub/pounds/CSC330/translations/$filename") or die "Couldn't open file $filename, $!";

#the next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>;

my @words = [];

#Now take each line and break it into tokens based on spaces and print the token
foreach my $line (@all_lines)
{
   my @tokens = split(' ', $line);
   foreach my $token (@tokens)
   {
     push($token, @words);
   }
}

foreach my $word (@words)
{
  print($word);
}

sub isWord
{
  foreach my $c (@_[0])
  {
    if($c =~ /[a-zA-Z]/) #if character is a letter'
    {
      return true;
    }
  }
  return false;
}

# usage: is_element_of($element,@set);
# returns 1 if $element is a member of @set
sub contains {
    my $item = @_[0];
    return 1 if grep { $item eq $_ }@_;
}
