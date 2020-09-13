#!/usr/bin/python3

def isWord(word):
    for c in word:
        if c.isalpha():
            return True
    return False

def getInput():
    words = []
    with open("/pub/pounds/CSC330/translations/" + sys.argv[1],'r') as file:
        for line in file:
            for token in line.split():
                if isWord(token):
                    words.append(token)
    return words


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
    #remove punctuation from beginning
    if not word[0].isalpha():
      word = word[1:]

    #remove punctuation from end
    if not word[-1].isalpha():
      word = word[:-1]

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

import sys
if len(sys.argv) != 2:
      print("Error: There must be exactly one command line argument.")
      sys.exit()

words = getInput()
numWords = len(words)
numSyllables = countTotalSyllables(words)
numSentences = countSentences(words)


print("numWords = ", numWords)
print("numSyllables = ", numSyllables)
print("numSentences = ", numSentences)
