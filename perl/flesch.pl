#!/usr/bin/perl
use strict;
use warnings;

# Grab the name of the file from the command line, exit if no name given
my $filename = $ARGV[0] or die "Need to get file name on the command line\n";

# Use the filename
open(DATA, "/pub/pounds/CSC330/translations/$filename") or die "Couldn't open file $filename, $!";

#the next line puts all the lines from the text file into an array called @all_lines
my @all_lines = <DATA>;

my @words = ();

#Now take each line and break it into tokens based on spaces and print the token
foreach my $line (@all_lines)
{
   my @tokens = split(' ', $line);
   foreach my $token (@tokens)
   {
     push(@words, $token) if isWord($token);
   }
}


my $numWords = scalar(@words);
my $numSentences = countSentences(@words);
my $numSyllables = countTotalSyllables(@words);
my $numDifficultWords = countDifficultWords(@words);

print("numWords = $numWords\n");
print("numSentences = $numSentences\n");
print("numSyllables = $numSyllables\n");
print("numDifficultWords = $numDifficultWords\n");


#Calculate Flesch Readability Index
my $alpha = $numSyllables / $numWords;
my $beta = $numWords / $numSentences;


my $fleschIndex = 206.835 - $alpha * 84.6 - $beta * 1.015;

#Calculate Flesch-Kinchaid Grade Level Index
my $fleschKinicaidIndex = $alpha * 11.8 + $beta * 0.39 - 15.59;
#
# #Calculate Dale-Chall Readability Score
$alpha = $numDifficultWords / $numWords;
my $dalechall = $alpha * 100 * 0.1579 + $beta * 0.0496;
if ($alpha > 0.05)
{
  $dalechall += 3.6365
}

printf("Flesch Readability Index = %.0f \n", $fleschIndex);
printf("Flesch-Kinchaid Grade Level Index = %.1f \n", $fleschKinicaidIndex);
printf("Dale-Chall Readability Score = %.1f \n", $dalechall);

sub getEasyWords
{
  open(FH, "/pub/pounds/CSC330/dalechall/wordlist1995.txt") or die "Couldn't open Dale Chall wordlist, $!";
  my %easyWords;
  my @words = <FH>;
  chomp(@words);
  foreach my $word (@words)
  {
     $easyWords{lc($word)} = 1;
  }
  return %easyWords;
}

sub countDifficultWords
{
  my %easyWords = getEasyWords();
  my $count = 0;
  foreach my $word (@_)
  {
    if(not $easyWords{stripWord(lc($word))})
    {
      $count += 1;
    }
  }
  return $count;
}

sub isAlpha
{
  return $_[0] =~ /[a-zA-Z]/;
}

sub isWord
{
  foreach my $c ($_[0])
  {
    if(isAlpha($c)) #if character is a letter'
    {
      return 1;
    }
  }
  return 0;
}

sub countSentences
{
  my $count = 0;
  foreach my $word (@_)
  {
    my $lastChar = substr($word, -1);
    if ($lastChar eq '.' or $lastChar eq ':' or $lastChar eq  ';' or $lastChar eq '?' or $lastChar eq '!')
    {
      $count += 1;
    }
  }
  return $count;
}

sub countTotalSyllables
{
  my $count = 0;
  foreach my $word (@_)
  {
    $count += countSyllables($word);
  }
  return $count;
}

sub countSyllables
{
  my $word = $_[0];
  $word = stripWord($word);

  my $numSyllables = countSyllablesRecursive($word);
  if ($numSyllables == 0)
  {
    $numSyllables = 1;
  }
  return $numSyllables;
}

sub countSyllablesRecursive
{
  my $word = $_[0];
  if (length($word) == 0) #empty string base case
  {
    return 0;
  }

  if (isVowel(substr($word, 0, 1)))
  {

    if(length($word) == 1) #if the word is only one character, then it is only 1 syllable
    {
      if ($word eq 'e') #unless it is e, this avoids counting e's at the end of words
      {
        return 0;
      }
      else
      {
        return 1;
      }
    }

    my $firstConsonant = 1; #the index of the first consonant
    while(isVowel(substr($word, $firstConsonant, 1)))
    {
      if($firstConsonant == length($word) - 1) #if we've reached the ned of the word, i.e. ther were no consonants
      {
        return 1;
      }
      else
      {
        $firstConsonant += 1;
      }
    }
    return 1 + countSyllablesRecursive(substr($word, $firstConsonant));

  }
  else
  {
    return countSyllablesRecursive(substr($word, 1));
  }
}

sub stripWord
{
  my $word = $_[0];
  #remove punctuation from beginning
  if(not isAlpha(substr($word, 0, 1)))
  {
    $word = substr($word, 1);
  }
  #remove punctation from end
  if(not isAlpha(substr($word, -1)))
  {
    $word = substr($word, 0, -1);
  }

  return $word;
}

sub isVowel
{
  my $char = lc($_[0]);
  return 1 if($char eq 'a' or $char eq 'e' or $char eq 'i' or $char eq 'o' or $char eq 'u' or $char eq 'y');

  return 0;
}
