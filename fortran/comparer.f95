program stringprocess
character(:), allocatable  :: long_string, comparison
integer :: filesize
! Let's define a command line argument
character(len=50) :: cla

interface

logical function sameString( string1, string2 ) result( out )
character(:), allocatable :: string1, string2
end function sameString

function to_upper(in) result(out)
implicit none
character(*), intent(in)  :: in
character(:), allocatable :: out
end function to_upper

end interface

call get_command_argument(1, cla)

print *, cla
long_string = " Good "
comparison = cla

if ( sameString(to_upper(long_string), to_upper(comparison) )) then
    print *, "The strings are the same"
else
    print *, "The strings are not the same"
endif

end program stringprocess

logical function sameString ( string1, string2 ) result(out)

character(:), allocatable :: string1, string2
out = .false.

if ( len(trim(adjustl(string1))) .eq. len(trim(adjustl(string2))) ) then
    if ( index(trim(adjustl(string1)), trim(adjustl(string2))) .ne. 0 ) out = .true.
endif

end function sameString


function to_upper(in) result(out)

character(*), intent(in)  :: in
character(:), allocatable :: out
integer                   :: i, j

! The following should work with any character set 
character(*), parameter   :: upp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
character(*), parameter   :: low = 'abcdefghijklmnopqrstuvwxyz'
out = in                                            
do i = 1, LEN_TRIM(out)             
    j = INDEX(low, out(i:i))        
    if (j > 0) out(i:i) = upp(j:j)  
end do

end function to_upper

