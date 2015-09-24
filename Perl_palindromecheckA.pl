#!/usr/bin/perl

print "Enter a string please:\n";

$isPalindrome = 1; #this variable is used so I know at the end if we have a palidrome.  If isPalindrome remains 1, then the input is a palindrome
$input = <>;
$palindrome = $input; #so that i remember what the user entered
while (length($input) > 1 and $isPalindrome == 1) 
	{
		$input =~ m/^(.)(.*)(.)$/;
		if ($1 eq $3)
			{
				$input = $2;
			}
		else 
			{
				print "$palindrome is not a palindrome\n";
				$isPalindrome = 0;    
			}
	}
if ($isPalindrome)
	{
		print "$palindrome is a palindrome\n";
	}
