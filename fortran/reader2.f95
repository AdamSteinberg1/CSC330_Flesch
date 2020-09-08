program reader

character (LEN=5000000) :: long_string
integer :: filesize

call read_file( long_string, filesize )

print *, long_string
print *, "Read ", filesize, " characters."

end program reader



subroutine read_file( string, counter )

character (LEN=*) :: string
integer :: counter
character (LEN=1) :: input

open (unit=5,status="old",access="direct",form="unformatted",recl=1,file="/pub/pounds/CSC330/translations/KJV.txt")

counter=1
100 read (5,rec=counter,err=200) input
    string(counter:counter) = input
    counter=counter+1
    goto 100
200 continue
counter=counter-1

close (5)

end subroutine read_file

