
#include <iostream>
#include <vector>
#include <fstream>

using namespace std;

bool isWord(string s)
{
  //returns true if there is at least one alphabetic character
  for(char c : s)
  {
    if(isalpha(c))
      return true;
  }
  return false;
}

vector<string> getInput(string filename)
{
  vector<string> words;
  ifstream file;
  file.open("/pub/pounds/CSC330/translations/" + filename);
  if(!file.is_open())
  {
    cout << "Error: Could not open specified file.\n";
    exit(1);
  }

  string word;
  while(file >> word)
  {
    if(isWord(word))
      words.push_back(word);
  }
  return words;
}

bool isVowel(char c)
{
  switch (tolower(c))
  {
      case 'a':
      case 'e':
      case 'i':
      case 'o':
      case 'u':
      case 'y':
          return true;
      default:
        return false;
  }
}

int countSyllablesRecursive(string word)
{
  if(word.length() == 0) //empty string has no syllables
    return 0;

  if(isVowel(word[0]))
  {
    if(word.length() == 1) //if the word is only 1 character, then it is only 1 syllable
    {
      if(word[0] == 'e') //unless it is e, this avoids counting e's at the end of words
        return 0;
      else
        return 1;
    }

    int firstConsonant = 1; //the index of the first consonant
    {
      while (isVowel(word[firstConsonant]))
      {
        if(firstConsonant == word.length()-1) //if we've reached the end of the word, i.e. there were no consonants
          return 1;
        else
          firstConsonant++;
      }
    }
    return 1 + countSyllablesRecursive(word.substr(firstConsonant));
  }
  else
  {
    return countSyllablesRecursive(word.substr(1)); //count the syllables in all the characters except the first
  }
}

int countSyllables(string word)
{
  //remove punctuation from beginning
  if(!isalpha(word[0]))
  {
    word = word.substr(1);
  }
  //remove punctuation from end
  int lastIndex = word.length()-1;
  if(!isalpha(word[lastIndex]))
  {
    word = word.substr(0, lastIndex);
  }

  int numSyllables = countSyllablesRecursive(word);

  if (numSyllables == 0)
    numSyllables = 1; //no word can have 0 syllables

  return numSyllables;
}

int countTotalSyllables(vector<string> words)
{
  int count = 0;
  for(string word: words)
  {
    count += countSyllables(word);
  }
  return count;
}

int main(int argc, char *argv[])
{
  if(argc != 2)
  {
    cout << "Error: There must be exactly one command line argument.\n";
    exit(1);
  }

  vector<string> words = getInput(argv[1]);
  int numWords = words.size();
  int numSyllables = countTotalSyllables(words);

  cout << "numWords = " << numWords << endl;
  cout << "numSyllables = " << numSyllables << endl;
}
