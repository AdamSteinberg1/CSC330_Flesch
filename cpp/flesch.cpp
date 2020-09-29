
#include <iostream>
#include <vector>
#include <unordered_set>
#include <fstream>
#include <math.h>

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

string stripWord(string word)
{
  //remove punctation from beginning
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
  return word;
}

int countSyllables(string word)
{
  word = stripWord(word);

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

int countSentences(vector<string> words)
{
  int count = 0;
  for(string word: words)
  {
    char c = word.back(); //last character in word
    switch(c)
    {
      case '.':
      case ':':
      case ';':
      case '?':
      case '!':
        count++;
    }
  }
  return count;
}

string tolower(string word)
{
  string result = "";
  for(char c : word)
    result += tolower(c);
  return result;
}

unordered_set<string> getEasyWords()
{
  unordered_set<string> easyWords;
  ifstream file;
  file.open("/pub/pounds/CSC330/dalechall/wordlist1995.txt");
  if(!file.is_open())
  {
    cout << "Error: Could not open Dale-Chall word list.\n";
    exit(1);
  }

  string word;
  while(file >> word)
  {
    easyWords.insert(tolower(word));
  }
  return easyWords;
}



int countDifficultWords(vector<string> words)
{
  unordered_set<string> easyWords = getEasyWords();
  int count = 0;
  for(string word : words)
  {
    if(!easyWords.count(stripWord(tolower(word)))) //if the word is not an easy word
      count++;
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
  int numSentences = countSentences(words);
  int numDifficultWords = countDifficultWords(words);

  //for debugging
  /*
  cout << "numWords = " << numWords << endl;
  cout << "numSyllables = " << numSyllables << endl;
  cout << "numSentences = " << numSentences << endl;
  cout << "numDifficultWords = " << numDifficultWords << endl;
  */

  //Calculate Flesch Readability Index
  double alpha = (double) numSyllables / numWords;
  double beta = (double) numWords / numSentences;

  int fleschIndex = (int)round(206.835 - alpha * 84.6 - beta * 1.015);

  //Calculate Flesch-Kinchaid Grade Level Index
  double fleschKincaidIndex = alpha * 11.8 + beta * 0.39 - 15.59;

  //Calculate Dale-Chall Readability Score
  alpha = (double) numDifficultWords / numWords;
  double dalechall = alpha * 100 * 0.1579 + beta * 0.0496;
  if (alpha > 0.05)
    dalechall += 3.6365;


  printf("Flesch Readability Index = %d\n", fleschIndex);
  printf("Flesch-Kincaid Grade Level Index = %.1f\n", fleschKincaidIndex);
  printf("Dale-Chall Readability Score = %.1f\n", dalechall);
}
