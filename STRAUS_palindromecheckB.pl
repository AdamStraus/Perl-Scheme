#!/usr/bin/perl

print "Enter a string:\n";

$specialCase = 0; #there is a special case where $input length is 2 and one of the characters is a space , . ; it was not saying this was a palindrome then.  Special case checks to see if there are two characters and if one is the special characters to ignore.  If this is the case then you already have a palidrome, no more checks are needed

$isPalindrome = 1; #this variable is used so I know at the end if we have a palidrome.  If isPalindrome remains 1, then the input is a palindrome

$input = <>;
$palindrome = $input;
chomp($palindrome); #for some reason it had a newline it is so I'm just getting rid of that
while (length($input) > 1 and $isPalindrome == 1)
	{
		$input =~ m/^(.)(.*)(.)$/;
		while ($1 =~ m/\,|\.|\;|\s/)
			{
				if (length($input) == 2)
					{
						$specialCase = 1; #if length is two, and one of the characters is a special character, then we have hit our special case and we have a palindrome
					}
				$input =~ m/^(.)(.*)(.)$/;  #need to reset $1, $2, and $3 so I can concatonate correctly
				$input = $2.$3;
				$input =~ m/^(.)(.*)(.)$/;  #need to reset $1, $2 and $3 so the while loops will catch special characters again
			}
		while ($3 =~ m/\,|\.|\;|\s/)
			{
				if (length($input) == 2)
					{
						$specialCase = 1;
					}
				$input =~ m/^(.)(.*)(.)$/;
				$input = $1.$2;
				$input =~ m/^(.)(.*)(.)$/;
			}

		if ($specialCase) #if we encoutnered the special case, then we have a palindrome
			{
				last;
			}

		$input =~ m/^(.)(.*)(.)$/; #it seems like $1 and $3 have been reset when i get here so I do another match

		$firstMatch = $1;
		$secondMatch = $3;
		$firstMatch = lc($firstMatch);
		$secondMatch = lc($secondMatch);  #I do this so case is ignored.  Could also do this with a reg expression with i at the end

		if ($firstMatch eq $secondMatch)
			{
				$input = $2;
			}
		else 
			{ 
				$isPalindrome = 0;
			}
	}

if ($isPalindrome)
	{
		print "$palindrome is a palindrome if I ignore whitespace and punctuation and case\n";
	} 
else
	{
		print "$palindrome is not a palindrome even if I ignore whitespace and punctuation and case\n";
	}
				
