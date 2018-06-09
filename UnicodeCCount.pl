#!/usr/bin/perl
use strict;
use v5.8.1;
use charnames ':full';

use Encode;
use Unicode::Normalize;
use Unicode::Collate;
use File::Spec;

use Getopt::Std;
use Encode;


our $Version = 0.5;	# 2018-06-08
#	Added -n character names for HJP3
#our $Version = 0.4;	# 2012-06-15
#	Added -b UTF8 BOM signature for HJP3
#our $Version = 0.3;	# 2005-10-15
#	Added -f and -r options for JW
#our $Version = 0.2;	# 2004-09-08
#	Added -o, -c, -n, -m, -u options
#	Count CR and LF separately.
#our $Version = 0.1;
#  2004-08-03 Original coding by Bob Hallissy


our ($opt_b, $opt_c, $opt_d, $opt_e, $opt_f, $opt_l, $opt_o, $opt_m, $opt_r, $opt_u, $opt_n, $opt_g);
getopts('bcde:flo:mru:ng');


my ($encoding, $file);

if ($opt_e)
{
	$encoding = Encode::resolve_alias($opt_e);
	die "Cannot locate definition for encoding '$opt_e'." unless defined $encoding;
}
else
{
	$encoding = 'utf8';
}

if ($opt_o)
{
	close STDOUT;
	open STDOUT, ">$opt_o" || die ("Can't open '$opt_o' for writing.");
}

if ($opt_l)
{
	print "List of available encodings:\n";
	my $f = (-t STDOUT ? "%-20s" : "%s\n");
	map { printf $f, $_} Encode->encodings(':all');
	exit;
}

die <<"eof" unless $#ARGV >= 0;
Usage:
    UnicodeCCount [-e encoding] [-c|-d] [-m] [-u|-f] [-r] [-b] file ....
    UnicodeCCount -l

A quick and dirty character counter that understands various encodings.
Writes to STDOUT unless -o is specified.

Input defaults to utf8, but you can choose other encodings with -e.
Data is converted from the specified encoding to Unicode as it is
read, and the output data is always utf-8.

-o filename   output written to a file rather than to STDOUT.

-l   outputs a list of available encodings.

-c or -d   enforce Unicode normalization (NFC or NFD) as data is read.

-m   combining mark sequences (base + diacritics) counted separately.

-u   use the Unicode Collation Algorithm (UCA) rather than the default sort.

-f   sort by frequency

-r   reverse sort order

-b   include UTF-8 signature (BOM)

-n   include verbose names of unicode points

-g   when control charaters are counted, display control character glyphs from Control Picures Block

Version $Version

eof

binmode STDOUT, ':utf8';
print "\x{FEFF}" if $opt_b;

my $pattern = ($opt_m ? '\X' : '.');

my $collator;
if ($opt_u)
{
	# Unicode::Collation module requires an additional file be downloaded.
	# Make sure it is present
	my $path = $INC{'Unicode/Collate.pm'};
	$path =~ s/\.pm$//;
	die <<"EOS" if !(-r File::Spec->catfile($path, 'allkeys.txt'));

ERROR: Your Perl installation is missing the UCA keys file. Please download
http://www.unicode.org/Public/UCA/latest/allkeys.txt and put a copy into
the '$path' folder.

Or: omit the -u parameter.

(Note: It is normal for a Perl installation to be missing this file.
You are expected to download it if you use Unicode::Collate. See the module
documentation for more information.)

EOS

	$collator = Unicode::Collate->new() if $opt_u;	# No tailoring
}

for $file (@ARGV)
{
	unless (open (IN, "<:raw:encoding($encoding)", $file))
	{
		print "Couldn't open '$file' for reading: $!.\n";
		next;
	}

	print "Character count for '$file':\n";
	my ($char, %charcounts);

	while (my $line = <IN>)
	{
		$line = NFD($line) if $opt_d;
		$line = NFC($line) if $opt_c;

		map {$charcounts{$_}++} ($line =~ m/$pattern/ogs);
	}

	for $char (sort {$opt_u ? ($opt_r ? $collator->cmp($b, $a) : $collator->cmp($a, $b)) : $opt_f ? ($opt_r ? $charcounts{$b} <=> $charcounts{$a} : $charcounts{$a} <=> $charcounts{$b} ) : ($opt_r ? $b cmp $a : $a cmp $b)} keys %charcounts)
	{


		map {
			# Prints and concats the code point to $t
			my $codepoint = sprintf("U+%04X", ord($_));
			printf "U+%04X", ord($_);

			# Prints the glyph (or control char pic with -g) and the occurance count

			if($opt_g) {
				printf "\t%s\t%d\t", $char =~ /\p{IsGraph}/ ? $char : hot_lemon( $codepoint ), $charcounts{$char};
			}
			else {
				printf "\t%s\t%d\t", $char =~ /\p{IsGraph}/ ? $char : ' ', $charcounts{$char};
			}

		} split (//, $char);

		# Optionally print a glyph for glyphless characters

		# Optionally prints the unicaode name
		$opt_n ? map { print_name(ord($_)) } split (//, $char) : print "\n";

	}
}

sub print_name {
	 print charnames::viacode(@_);
	 print "\n";
}

sub hot_lemon {
	# Problem 1: The strings are not being matched (in our case we fall through and print the code point)
	# Problem 2: If we force a return value the character does not get printed
	# 						return "␀";

	if (@_ eq "U+0000") { return "␀" };
	if (@_ eq "U+0001") { return "␁" };
	if (@_ eq "U+0002") { return "␂" };
	if (@_ eq "U+0003") { return "␃" };
	if (@_ eq "U+0004") { return "␄" };
	if (@_ eq "U+0005") { return "␅" };
	if (@_ eq "U+0006") { return "␆" };
	if (@_ eq "U+0007") { return "␇" };
	if (@_ eq "U+0008") { return "␈" };
	if (@_ eq "U+0009") { return "␉" };
	if (@_ eq "U+000A") { return "␊" };
	if (@_ eq "U+000B") { return "␋" };
	if (@_ eq "U+000C") { return "␌" };
	if (@_ eq "U+000D") { return "␍" };
	if (@_ eq "U+000E") { return "␎" };
	if (@_ eq "U+000F") { return "␏" };
	if (@_ eq "U+0010") { return "␐" };
	if (@_ eq "U+0011") { return "␑" };
	if (@_ eq "U+0012") { return "␒" };
	if (@_ eq "U+0013") { return "␓" };
	if (@_ eq "U+0014") { return "␔" };
	if (@_ eq "U+0015") { return "␕" };
	if (@_ eq "U+0016") { return "␖" };
	if (@_ eq "U+0017") { return "␗" };
	if (@_ eq "U+0018") { return "␘" };
	if (@_ eq "U+0019") { return "␙" };
	if (@_ eq "U+001A") { return "␚" };
	if (@_ eq "U+001B") { return "␛" };
	if (@_ eq "U+001C") { return "␜" };
	if (@_ eq "U+001D") { return "␝" };
	if (@_ eq "U+001E") { return "␞" };
	if (@_ eq "U+001F") { return "␟" };
	if (@_ eq "U+007F") { return "␡" };
	if (@_ eq "U+00A0") { return "␠" };
	return @_;
}
