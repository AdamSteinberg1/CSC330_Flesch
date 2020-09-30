#!/usr/bin/python3
import sys

def isWord(word):
    for c in word:
        if c.isalpha():
            return True
    return False

def getInput():
    try:
        words = []
        with open("/pub/pounds/CSC330/translations/" + sys.argv[1], encoding="utf8", errors='ignore') as file:
            for line in file:
                for token in line.split():
                    if isWord(token):
                        words.append(token)
        return words
    except (FileNotFoundError):
        print("Error: Specified file does not exist.")
        sys.exit()

def stripWord(word):
    if not word[0].isalpha():
      word = word[1:]

    #remove punctuation from end
    if not word[-1].isalpha():
      word = word[:-1]

    return word


def countSyllablesRecursive(word):
    if len(word) == 0: #empty string base case
        return 0

    vowels = ['a', 'e', 'i', 'o', 'u', 'y']

    if word[0].lower() in vowels:

        if len(word) == 1: #if the word is only 1 character, then it is only 1 syllable
            if word == 'e': #unless it is e, this avoids counting e's at the end of words
                return 0
            else:
                return 1


        firstConsonant = 1 #the index of the first consonant

        while word[firstConsonant].lower() in vowels:
            if firstConsonant == len(word)-1: #if we've reached the end of the word, i.e. there were no consonants
                return 1
            else:
                firstConsonant += 1

        return 1 + countSyllablesRecursive(word[firstConsonant:])

    else:
        return countSyllablesRecursive(word[1:]) #count the syllables in all the characters except the first

def countSyllables(word):
    word = stripWord(word)

    numSyllables = countSyllablesRecursive(word)

    if numSyllables == 0:
      numSyllables = 1 #no word can have 0 syllables

    return numSyllables

def countTotalSyllables(words):
    count = 0
    for word in words:
      count += countSyllables(word)
    return count

def countSentences(words):
    punctuation = ['.', ':', ';', '?', '!']
    count = 0
    for word in words:
        if word[-1] in punctuation:
            count += 1
    return count

def getEasyWords():
    try:
        easyWords = set()
        with open('/pub/pounds/CSC330/dalechall/wordlist1995.txt','r') as file:
            for line in file:
                for token in line.split():
                    easyWords.add(token.lower())
        return easyWords;
    except (FileNotFoundError):
        print("Error: Dale Chall word list file does not exist.")
        sys.exit()

def countDifficultWords(words):
    easyWords = getEasyWords()
    count = 0
    for word in words:
      if stripWord(word.lower()) not in easyWords:
        count += 1
    return count

if len(sys.argv) != 2:
      print("Error: There must be exactly one command line argument.")
      sys.exit()

words = getInput()
numWords = len(words)
numSyllables = countTotalSyllables(words)
numSentences = countSentences(words)
numDifficultWords = countDifficultWords(words)

#for debugging
# print("numWords =", numWords)
# print("numSyllables =", numSyllables)
# print("numSentences =", numSentences)
# print("numDifficultWords =", numDifficultWords)

#Calculate Flesch Readability Index
alpha = numSyllables / numWords;
beta = numWords / numSentences;

fleschIndex = round(206.835 - alpha * 84.6 - beta * 1.015)

#Calculate Flesch-Kincaid Grade Level Index
fleschKincaidIndex = round(alpha * 11.8 + beta * 0.39 - 15.59, 1)

#Calculate Dale-Chall Readability Score
alpha = numDifficultWords / numWords;
dalechall = alpha * 100 * 0.1579 + beta * 0.0496;
if alpha > 0.05:
    dalechall += 3.6365
dalechall = round(dalechall, 1) #round to one decimal point

print("Flesch Readability Index =", fleschIndex);
print("Flesch-Kincaid Grade Level Index =", fleschKincaidIndex);
print("Dale-Chall Readability Score =", dalechall);
