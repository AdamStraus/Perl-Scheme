#!/usr/bin/perl

open (INF, "<", $ARGV[0]) or die "couldn't open sourcecode\n";

# these lines of code slurp the whole file into one scalar $in_buffer
   {
     local $/;
     $in_buffer = <INF>;
   }

   # use the following lines in your program if you wish to add a $ to
   # the end of the input program
chomp($in_buffer);
$in_buffer .= "\$";

&lex();
&program();


sub program
	{
		if ($nextToken = "program")
			{
				&lex;
			}
		else 
			{
				&error("was expecting 'program' but got $nextToken\n");
			}
		if ($nextToken = "PROGNAME")
			{
				&lex;
				&compound_stmt;
			}
		else 
			{
				&error("was expecting a PROGNAME but got $nextToken\n");
			}
		
	}


sub compound_stmt
	{
		if ($nextToken eq "begin")
			{
				&lex;
				&stmt;
			}
		else 
			{
				&error("was expecting 'begin' but got $nextToken\n");
			}
		

		while ($nextToken eq ";")
			{
				&lex;
				&stmt;
			}
		if ($nextToken eq "end")
			{
				&lex;
			}
		else 
			{
				&error("was expecting 'end' but got $nextToken\n");
			}
	}

sub stmt
	{
		if ($nextToken eq "VARIABLE" or $nextToken eq "read" or $nextToken eq "write")
			{
				&simple_stmt;

			}
		else
			{
				&structured_stmt;

			}
	}

sub structured_stmt
	{
		if ($nextToken eq "begin")
			{
				&compound_stmt;
			}
		elsif ($nextToken eq "if")
			{
				&if_stmt;
			}
		elsif ($nextToken eq "while")
			{
				&while_stmt;
			}
		else
			{
				&error("was expecting 'begin', 'if', or 'while', but got $nextToken");
			}
	}

sub if_stmt
	{
		if ($nextToken eq "if")
			{
				&lex;
				&expression;
			}
		else
			{
				&error("was expecting 'if' but got $nextToken\n");
			}
		if ($nextToken eq "then")
			{
				&lex;
				&stmt;
			}
		else 
			{
				error("was expecting 'then', but got $nextToken\n");
			}
		if ($nextToken eq "else")
			{
				&lex;
				&stmt;
			}
	
	}

sub while_stmt
	{

		if ($nextToken eq "while")
			{
				&lex;
				&expression;
			}
		else
			{
				&error("was expecting 'while' but got $nextToken\n");
			}
		if ($nextToken eq "do")
			{
				&lex;
				&stmt;
			}
		else
			{
				&error("was expecting 'do' but got $nextToken\n");
			}

	}

sub simple_stmt
	{

		if ($nextToken eq "VARIABLE")
			{
				&assignment_stmt;	

			}
		elsif ($nextToken eq "read")
			{
				&read_stmt;

			}
		else
			{
				&write_stmt;

			}
	}

sub assignment_stmt
	{

		if ($nextToken eq "VARIABLE")
			{
				&lex;

			}
		else
			{
				&error("was expecting a VARIABLE but got $nextToken\n");
			}
		if ($nextToken eq ":=")
			{
				&lex;
				&expression;
			}
		else 
			{
				&error("was expecting ':=' but got $nextToken\n");
			}
	}

sub read_stmt
	{

		if ($nextToken eq "read")
		{
			&lex;

		}
		else
		{
			&error("was expecting 'read' but got $nextToken\n");
		}

		if ($nextToken eq "(")
		{
			&lex;

		}
		else
		{
			&error("was expecting '(' but got $nextToken\n");
		}

		if ($nextToken eq "VARIABLE")
			{
				&lex;

			}
		else
			{
				&error("was expecting a VARIABLE but got $nextToken\n");
			}
		
		while ($nextToken eq ",")
			{
				&lex;

				if ($nextToken eq "VARIABLE")
					{
						&lex;

					}
				else
					{
						&error("was expecting VARIABLE but got $nextToken\n");
					}
				
			}
			
		if ($nextToken eq ")")
		{
			&lex;

		}
		else
		{
			&error("was expecting ')' but got $nextToken\n");
		}
	}


sub write_stmt
	{

		if ($nextToken eq "write")
		{
			&lex;
		}
		else
		{
			&error("was expecting 'write' but got $nextToken\n");
		}

		if ($nextToken eq "(")
		{
			&lex;

		}
		else
		{
			&error("was expecting '(' but got $nextToken\n");
		}

		&expression;



		while ($nextToken eq ",")
		{
			&lex;
			&expression;

		}
		
		if ($nextToken eq ")")
		{
			&lex;

		}
		else
		{
			&error("was expecting ')' but got $nextToken\n");
		}
		
	}

sub expression
	{
		&simple_expr;
			
		if ($nextToken eq "=" or $nextToken eq "<>" or $nextToken eq "<=" or $nextToken eq ">=" or $nextToken eq ">" or $nextToken eq "<" )
			{
				&lex;
				&simple_expr;

			}	
	}

sub simple_expr
	{

		if ($nextToken eq "+" or $nextToken eq "-")
			{
				&lex;

			}
		&term;
		while ($nextToken eq "+" or $nextToken eq "-")
			{
				&lex;
				&term;

			}
	}
sub term
	{
		&factor;
		while ($nextToken eq "*" or $nextToken eq "/")
			{
				&lex;
				&factor;
			}
		
	}

sub factor
	{
		if ($nextToken eq "VARIABLE")
			{
				&lex;
			}
		elsif ($nextToken eq "CONSTANT")
			{
				&lex;
			} 
		elsif ($nextToken eq "(")
			{
				&lex;
				&expression;
				if ($nextToken eq ")")
					{
						&lex;
					}
				else 
					{
						&error("was expecting a ) but got $nextToken\n");
					}
			}
		else 
			{
				&error("was expecting VARIABLE, CONSTANT, or ( but got $nextToken\n");
			}
	}


sub error
	{
		die($_[0]);
	}

sub lex
	{	
	print " -- $nextToken\n";
	if ($in_buffer =~ m/^(\s*)(program|begin|end|read|write|if|then|else|while|do)/)
		{
			$nextToken = $2;
			$in_buffer = $';
		}
	elsif ($in_buffer =~ m/^(\s*)(\;|\:=|\(|\,|\)|\+|\-|\*|\/|\=|\<\>|\<\=|\>\=|\<|\>)/)
		{
			$nextToken = $2;
			$in_buffer = $';
		}
	elsif ($in_buffer =~ m/^(\s*)[A-Za-z0-9]+/)
		{
			$nextToken = "VARIABLE";
			$in_buffer = $';
		}
	elsif ($in_buffer =~ m/^(\s*)([A-Z])[A-Za-z0-9]*/)
		{
			$nextToken = "PROGNAME";
			$in_buffer = $';
		}
	
	elsif ($in_buffer =~ m/^(\s*)([0-9])/)
		{
			$nextToken = "CONSTANT";
			$in_buffer = $';
		}
	elsif ($in_buffer eq "null")
		{
			&error("I DONT KNOW WHAT CHARACTER THIS IS");
		}

	}
print "YOU HAVE WORKING CODE!\n";
