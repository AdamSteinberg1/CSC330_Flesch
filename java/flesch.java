import java.util.*;
import java.io.*;

public class flesch {
  public static void main(String[] args)
  {
    if(args.length != 1)
    {
      System.err.println("Error: There must be exactly one command line argument.");
      System.exit(1);
    }

    ArrayList<String> words = getInput(args[0]);

    int numWords = words.size();
    int numSyllables = countTotalSyllables(words);
    int numSentences = countSentences(words);
    int numDifficultWords = countDifficultWords(words);

    //for debugging
    System.out.println("numWords = " + numWords);
    System.out.println("numSyllables = " + numSyllables);
    System.out.println("numSentences = " + numSentences);
    System.out.println("numDifficultWords = " + numDifficultWords);

    //Calculate Flesch Readability Index
    double alpha = (double) numSyllables / numWords;
    double beta = (double) numWords / numSentences;

    int fleschIndex = (int)Math.round(206.835 - alpha * 84.6 - beta * 1.015);

    //Calculate Flesch-Kincaid Grade Level Index
    double fleschKincaidIndex = alpha * 11.8 + beta * 0.39 - 15.59;
    fleschKincaidIndex = Math.round(fleschKincaidIndex * 10) / 10.0; //round to one decimal point

    //Calculate Dale-Chall Readability Score
    alpha = (double) numDifficultWords / numWords;
    double dalechall = alpha * 100 * 0.1579 + beta * 0.0496;
    if (alpha > 0.05)
      dalechall += 3.6365;
    dalechall = Math.round(dalechall *10) / 10.0; //round to one decimal point

    System.out.println("Flesch Readability Index = " + fleschIndex);
    System.out.println("Flesch-Kincaid Grade Level Index = " + fleschKincaidIndex);
    System.out.println("Dale-Chall Readability Score = " + dalechall);

  }

  private static ArrayList<String> getInput(String filename)
  {
    //returns an ArrayList of all the words in the input text file
    //all the valid filenames for the translations: ASV.txt  BBE.txt  DARBY.txt  DRB.txt  KJ21.txt  KJV.txt  NAB.txt  NASB.txt  NIV.txt  NKJV.txt  NLT.txt  WEB.txt  YLT.txt

    ArrayList<String> words = new ArrayList<String>();
    try
    {
      Scanner scan = new Scanner(new File("/pub/pounds/CSC330/translations/" + filename));
      int linesProcessed = 0;
      while (scan.hasNextLine())
      {
        String line = scan.nextLine();
        linesProcessed++;
        for(String token : line.split(" "))
        {
          if(isWord(token))
          {
            words.add(token);
          }
        }
      }
      scan.close();
      System.out.println("Last word processed is: " + words.get(words.size()-1));
      System.out.println("Lines Processed: " + linesProcessed);
    }
    catch (FileNotFoundException e)
    {
      System.err.println("Error: Specified file does not exist.");
      System.exit(1);
    }
    return words;
  }

  private static Boolean isWord(String s)
  {
    //returns true if there is at least one alphabetic character
    for(char c : s.toCharArray())
    {
      if(Character.isLetter(c))
        return true;
    }
    return false;
  }

  private static int countSentences(ArrayList<String> words)
  {
    int count = 0;
    for(String word: words)
    {
      char c = word.charAt(word.length()-1); //last character in word
      if (c == '.' || c == ':' || c == ';' || c == '?' || c == '!') //check if the last character is punctuation
      {
        count++;
      }
    }
    return count;
  }

  private static int countTotalSyllables(ArrayList<String> words)
  {
    int count = 0;
    for(String word: words)
    {
      count += countSyllables(word);
    }
    return count;
  }

  private static int countSyllables(String word)
  {
    word = stripWord(word);
    int numSyllables = countSyllablesRecursive(word);

    if (numSyllables == 0)
      numSyllables = 1; //no word can have 0 syllables

    //System.out.println(word + " " + numSyllables); //debugging TODO remove
    return numSyllables;
  }

  private static int countSyllablesRecursive(String word)
  {
    if(word.length() == 0) //empty string has no syllables
      return 0;

    if(isVowel(word.charAt(0)))
    {
      if(word.length() == 1) //if the word is only 1 character, then it is only 1 syllable
      {
        if(word.charAt(0) == 'e') //unless it is e, this avoids counting e's at the end of words
          return 0;
        else
          return 1;
      }

      int firstConsonant = 1; //the index of the first consonant
      {
        while (isVowel(word.charAt(firstConsonant)))
        {
          if(firstConsonant == word.length()-1) //if we've reached the end of the word, i.e. there were no consonants
            return 1;
          else
            firstConsonant++;
        }
      }
      return 1 + countSyllablesRecursive(word.substring(firstConsonant));
    }
    else
    {
      return countSyllablesRecursive(word.substring(1)); //count the syllables in all the characters except the first
    }
  }

  private static Boolean isVowel(char c)
  {
    switch (Character.toLowerCase(c))
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

  private static Set<String> getEasyWords()
  {
    Set<String> easyWords = new HashSet<String>();
    try
    {
      Scanner scan = new Scanner(new File("/pub/pounds/CSC330/dalechall/wordlist1995.txt"));
      while (scan.hasNext())
      {
        easyWords.add(scan.next().toLowerCase());
      }
      scan.close();
    }
    catch (FileNotFoundException e)
    {
      System.err.println("Error: Could not find list of easy words for Dale-Chall.");
      System.exit(1);
    }
    return easyWords;
  }

  private static int countDifficultWords(ArrayList<String> words)
  {
    Set<String> easyWords = getEasyWords();
    int count = 0;
    for(String word : words)
    {
      if(!easyWords.contains(stripWord(word.toLowerCase())))
        count++;
    }
    return count;
  }

  private static String stripWord(String word)
  {
    //remove punctuation from beginning
    if(!Character.isLetter(word.charAt(0)))
    {
      word = word.substring(1);
    }
    //remove punctuation from end
    int lastIndex = word.length()-1;
    if(!Character.isLetter(word.charAt(lastIndex)))
    {
      word = word.substring(0, lastIndex);
    }
    return word;
  }
}
