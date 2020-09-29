program flesch
	integer :: numWords, numSentences, numSyllables, numDifficultWords, fleschIndex
	character(50), dimension(:), allocatable :: DaleChall
	real :: alpha, beta, fleschKincaidIndex, daleChallScore
	call getDaleChall(DaleChall)

	call read_file( numWords, numSentences, numSyllables, numDifficultWords, DaleChall )

	print *, "numWords = ", numWords
	print *, "numSentences = ", numSentences
	print *, "numSyllables = ", numSyllables
	print *, "numDifficultWords = ", numDifficultWords

  !Calculate Flesch Readability Index
	alpha = real(numSyllables) / numWords
	beta = real(numWords) / numSentences

	fleschIndex = nint(206.835 - alpha * 84.6 - beta * 1.015)

  !Calculate Flesch-Kinchaid Grade Level Index
	fleschKincaidIndex = alpha * 11.8 + beta * 0.39 - 15.59

	!Calculate Dale-Chall Readability Score

	alpha = real(numDifficultWords) / numWords;
  daleChallScore = alpha * 100 * 0.1579 + beta * 0.0496
  if (alpha > 0.05) then
    daleChallScore = daleChallScore + 3.6365
	end if

	PRINT 1100,  "Flesch Readability Index = ", fleschIndex
	PRINT 1000, "Flesch-Kincaid Grade Level Index = ", fleschKincaidIndex

	PRINT 1000, "Dale-Chall Readability Score = ", daleChallScore
1000 format (A, F4.1)
1100 format (A, I2)

contains

	subroutine read_file( numWords, numSentences, numSyllables, numDifficultWords, DaleChall )
		character(100) :: word
		character(50) :: cla
		character(*), dimension(:) :: DaleChall
		integer :: counter, numWords, numSentences, numSyllables, numDifficultWords
		character (1) :: input

		numWords = 0
		numSentences = 0
		numSyllables = 0
		numDifficultWords = 0

		call get_command_argument(1, cla)
		if(len_trim(cla) == 0) then
				print *, "Error: There must be one command line argument"
				call exit()
		end if
		open (unit=5,status="old",access="direct",form="unformatted",recl=1,file="/pub/pounds/CSC330/translations/" // cla)

		word = ""
		counter=1
		100 read (5,rec=counter,err=200) input
				if (input == " " .or. input == achar(10)) then !if input character is just whitespace, i.e. this is the end of the word
					if(isWord(word)) then
						call processWord(trim(word), numWords, numSentences, numSyllables, numDifficultWords, DaleChall)
					end if
					word = ""
				else
					word = trim(word) // input
				end if
				counter=counter+1
				goto 100
		200 continue
		close (5)
		!Process the last word
		if(isWord(word)) then
			call processWord(trim(word), numWords, numSentences, numSyllables, numDifficultWords, DaleChall)
		end if
	end subroutine read_file

	subroutine getDaleChall( DaleChall )
		character(*), dimension(:), allocatable :: DaleChall
		character(50), dimension(3000) :: words
		character (1) :: input
		character (50) :: word
		integer :: counter, index

		open (unit=5,status="old",access="direct",form="unformatted",recl=1,file="/pub/pounds/CSC330/dalechall/wordlist1995.txt")

		word = ""
		counter=1
		index = 1
		100 read (5,rec=counter,err=200) input
				if (input == " " .or. input == achar(10)) then !if input character is just whitespace, i.e. this is the end of the word
					words(index) = to_lower(word)
					index = index + 1
					word = ""
				else
					word = trim(word) // input
				end if
				counter=counter+1
				goto 100
		200 continue
		close (5)

		DaleChall =  words(1:index)

		call sort(DaleChall)  !the list of words is not quite sorted
													!We have to sort it so we can perform a binary search later

	end subroutine getDaleChall


	subroutine processWord(word, numWords, numSentences, numSyllables, numDifficultWords, DaleChall)
		character(*) :: word
		character(*), dimension(:) :: DaleChall
		integer :: counter, numWords, numSentences, numSyllables, numDifficultWords
		numWords = numWords + 1

		numSentences = numSentences + isEndOfSentence(word)

		numSyllables = numSyllables + countSyllables(word)

		numDifficultWords = numDifficultWords + isDifficult(word, DaleChall)

	end subroutine processWord

	integer function isDifficult(inword, DaleChall) result(out)
		character(*) :: inword
		character(:), allocatable :: word, item
		character(*), dimension(:) :: DaleChall
		integer :: index, l, r, m

		word = to_lower(stripWord(inword))

		l = 0
		r = size(DaleChall) - 1
		do while (l <= r)
				m = (l + r) / 2

				item = to_lower(trim(DaleChall(m+1)))
				! Check if present at mid
				if (word == item) then
						out = 0
						return
				end if

				! If greater, ignore left half
			  if (item < word) then
						l = m + 1

				! If smaller, ignore right half
				else
						r = m - 1
				end if
		end do

		! if we reach here, then element was not present
		out = 1


	end function isDifficult

	function isWord(word)
		logical :: isWord
		character(*) :: word
		if(scan(word, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == 0) then !if the word does not contain any alphabetic characters
			isWord = .false.
		else
			isWord = .true.
		end if

	end function isWord

	integer function countSyllables(inword) result(count)
	 character(*) :: inword
	 character(:), allocatable :: word
	 character(1) :: lastChar

	 word = stripWord(inword) !remove punctation from beginning and end

		count = countSyllablesRecursive(word)

		if (count == 0) then
			count = 1 !no word can have 0 syllables
		end if

	end function countSyllables

	function stripWord(inword) result(outword)
		character(:), allocatable :: outword
		character(*) :: inword
		outword = inword
		if( scan(outword(1:1), "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == 0 ) then !if the first character is not alphabetic
			outword = outword(2:)
		end if

		!remove punctuation from end
		if( scan(outword(len(outword):), "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == 0 ) then !if the last character is not alphabetic
			outword = outword(1:len(outword)-1)
		end if

	end function stripWord

	logical function isVowel(char) result(out)
		character(1) :: char
		if (scan(char, "aeiouyAEIOUY") == 0) then
			out = .false.
		else
			out = .true.
		end if
	end function isVowel

	recursive integer function countSyllablesRecursive(word) result(count)
		character(*) :: word
		integer :: firstConsonant


		if(len(word) == 0) then
			count = 0
			return
		end if

		 if (isVowel(word(1:1))) then

			 if (len(word) == 1) then!if the word is only 1 character, then it is only 1 syllable
				 if(word(1:1) == "e") then!unless it is e, this avoids counting e's at the end of words
					 count = 0
					 return
				 else
					 count = 1
					 return
				 end if
			 end if

			 firstConsonant = 2 !the index of the first consonant

				 do while (isVowel(word(firstConsonant:firstConsonant)))

					 if(firstConsonant == len(word)) then !if we've reached the end of the word, i.e. there were no consonants
						 count = 1
						 return
					 else
						 firstConsonant = firstConsonant + 1
					 end if
				 end do

				 count = 1 + countSyllablesRecursive(word(firstConsonant:))
				 return

		 else
			 count =  countSyllablesRecursive(word(2:)) !count the syllables in all the characters except the first
		 end if
	end function countSyllablesRecursive

	function isEndOfSentence(word)
		integer :: isEndOfSentence, n
		character(*) :: word
		character(1) :: lastChar
		n = len(word)
		lastchar = word(n:n)
		if (lastChar == "." .or. lastChar == ":" .or. lastChar == ";" .or. lastChar == "?" .or. lastChar == "!") then
			isEndOfSentence = 1
		else
			isEndOfSentence = 0
		end if

	end function isEndOfSentence

	function to_lower(in) result(out)

		character(*), intent(in)  :: in
		character(:), allocatable :: out
		integer                   :: i, j

		! The following should work with any character set
		character(*), parameter   :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
		character(*), parameter   :: low = 'abcdefghijklmnopqrstuvwxyz'
		out = in
		do i = 1, LEN_TRIM(out)
		    j = INDEX(upp, out(i:i))
		    if (j > 0) out(i:i) = low(j:j)
		end do


	end function to_lower

	subroutine sort(a) !an insertion sort
    integer :: n, i, j
    character(*), dimension(:) :: a
		character(:), allocatable :: x

		n = size(a)

    do i = 2, n
        x = a(i)
        j = i - 1
        do while (j >= 1)
            if (a(j) <= x) exit
            a(j + 1) = a(j)
            j = j - 1
        end do
        a(j + 1) = x
    end do
end subroutine

end program flesch
