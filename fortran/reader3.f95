program reader
character, dimension(:), allocatable  :: long_string
integer :: filesize

interface
subroutine read_file( string, filesize )
character, dimension(:), allocatable :: string
integer :: filesize
end subroutine read_file
end interface

call read_file( long_string, filesize )
print *, long_string
print *, "Read ", filesize, " characters."
end program reader

subroutine read_file( string, filesize )
character, dimension(:), allocatable :: string
integer :: counter
integer :: filesize
character (LEN=1) :: input

inquire (file="/pub/pounds/CSC330/translations/KJV.txt", size=filesize)
open (unit=5,status="old",access="direct",form="unformatted",recl=1,&
        file="/pub/pounds/CSC330/translations/KJV.txt")
allocate( string(filesize) )

counter=1
100 read (5,rec=counter,err=200) input
    string(counter:counter) = input
    counter=counter+1
    goto 100
200 continue
counter=counter-1
close (5)
end subroutine read_file

