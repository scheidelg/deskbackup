#!/bin/bash

#=============================================================================
# hexdiff.sh
#-----------------------------------------------------------------------------
# See display_usage() and main code.
#-----------------------------------------------------------------------------
# (c) Greg Scheidel, 2020.03.18
#-----------------------------------------------------------------------------

#=============================================================================
# display_usage ()
#-----------------------------------------------------------------------------
# Display the usage and help for the script. 
# 
#-----------------------------------------------------------------------------
# Local Variables
#
# None
# 
#-----------------------------------------------------------------------------
# Global Variables Referenced
#
# $0    Name of executed script
#-----------------------------------------------------------------------------
display_usage () {

cat <<EOF
SYNOPSIS

    $0 -h
    $0 [-c=b|n|B] [-b] [-m] [-o] <file1> <file2>

DESCRIPTION

    Compare two files (binary or text) and extract differences using a
    bit-by-bit (-c=b), nibble-by-nibble (-c=n), or byte-by-byte (-c=B)
    comparison.  The differences are identified by comparing the hexdump of
    each file.  Defaults to byte-by-byte comparison.

    This is potentially useful to inspect files for content hidden using
    steganographic techniques. 

    Output only includes the bits, nibbles, or bytes that are different
    between the two files.  See the '-c' option for details.

    Bit-by-bit comparison output is displayed in binary; nibble-by-nibble and
    byte-by-byte comparison output is displayed in hexadecimal by default but
    can be switched to binary (-b).  See the '-c' and '-b' options for
    details.

    By default the output shows the data in <file2> that are different from
    the corresponding data in <file1>.  See the '-m' option for details.

    Output can also show the data in <file1> that are different from the
    corresponding data in <file2>.  See the '-o' option, and '-m with -o'
    under COMBINING OUTPUT OPTIONS.
    
    Data are compared only to the end of the smaller of the two files.

ARGUMENTS

    <file1>

        The name of the original file to compare against the modified file.

    <file2>

        The name of the modified file to compare against the original file.

OPTIONS

    -b  Display the output of a nibble-by-nibble or byte-by-byte comparison in
        binary instead of hexadecimal.

        For example, if the output of a nibble-by-nibble comparison were:

            5:d:a:1:e:0:c:6:2

        Then use of '-b' would generate:

            0101:1101:1010:0001:1110:0000:1100:0110:0010

        If the output of a byte-by-byte comparision were:

            05:2d:6a:e1:be:00:1c:46:f2

        Then use of '-b' would generate:

            00000101:00101101:01101010:11100001:10111110:00000000:00011100:01000110:11110010

    -c=b

        Perform a bit-by-bit comparison of the two files.

        Bit comparison output is a string of colon-delimited binary characters
        (i.e., 0 or 1), where each group contains one character representing a
        bit-level difference.  For example:
        

            0:1:1:0:1:0

        See the '-m' and '-o' options for more detail.

        Default: Disabled.

    -c=n

        Perform a nibble-by-nibble comparison of the two files.  A nibble is
        4 bits, or one-half a byte.

        Nibble comparison output defaults to a string of colon-delimited
        hexadecimal characters (i.e., 0-9, a-f), where each group contains one
        character representing a nibble-level difference.  For example:

            5:d:a:1:e:0:c:6:2

        See the '-m' and '-o' options for more detail.

        Nibble comparison output can be displayed in binary instead of
        hexadecimal with the '-b' option.

        Default: Disabled.

    -c=B

        Perform a byte-by-byte comparison of the two files.

        Byte comparison output defaults to a string of colon-delimited
        hexadecimal characters (i.e., 0-9, a-f), where each group contains two
        characters representing a byte-level difference.  For example:

            05:2d:6a:e1:be:00:1c:46:f2

        See the '-m' and '-o' options for more detail.

        Byte comparison output can be displayed in binary instead of
        hexadecimal with the '-b' option.

        Default: Enabled.

    -h  Display usage (this content).

    -m  Display the data from <file2> that are different from the data in
        <file1>.

        For example, with files:

            -----start: file1.txt-----
            abcdefgHijklmnopqRstuvwxyz text
            -----end: file1.txt-----

            -----start: file2.txt-----
            abCdefghijklMnopqrstuvwxYz type
            -----end: file2.txt-----

        Performing a byte-by-byte comparision with  '-c=B' and '-m':

            \$ $0 -c=B -m file1.txt file2.txt
            43:68:4d:72:59:79:70:65

        We can see the basis for this output by examining the hexdump of
        file1.txt:

            Byte Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 6364 6566 6748 696a 6b6c 6d6e 6f70  abcdefgHijklmnop
            016: 7152 7374 7576 7778 797a 2074 6578 74    qRstuvwxyz text

        And the hexdump of file2.txt:

            Byte Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 4364 6566 6768 696a 6b6c 4d6e 6f70  abCdefghijklMnop
            016: 7172 7374 7576 7778 597a 2074 7970 65    qrstuvwxYz type

        We can see that:

         - Byte 2 is 0x63 ('c') in file1.txt; 0x43 ('C') in file2.txt

         - Byte 7 is 0x48 ('H') in file1.txt; 0x68 ('h') in file2.txt

         - Byte 12 is 0x6d ('m') in file1.txt; 0x4d ('M') in file2.txt

         - Byte 17 is 0x52 ('R') in file1.txt; 0x72 ('r') in file2.txt

         - Byte 24 is 0x79 ('y') in file1.txt; 0x59 ('Y') in file2.txt

         - Byte 28 is 0x65 ('e') in file1.txt; 0x79 ('y') in file2.txt

         - Byte 29 is 0x78 ('x') in file1.txt; 0x70 ('p') in file2.txt

         - Byte 30 is 0x74 ('t') in file1.txt; 0x65 ('e') in file2.txt

        ----------------------------------------------------------------------
        Performing a nibble-by-nibble comparision with '-c=n' and '-m':

            \$ $0 -c=n -m file1.txt file2.txt
            4:6:4:7:5:7:9:0:6:5

        Once again, we can see the basis for this output by examining the
        hexdump of file1.txt:

            Nibble Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 6364 6566 6748 696a 6b6c 6d6e 6f70  abcdefgHijklmnop
            032: 7152 7374 7576 7778 797a 2074 6578 74    qRstuvwxyz text

        And the hexdump of file2.txt:

            Nibble Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 4364 6566 6768 696a 6b6c 4d6e 6f70  abCdefghijklMnop
            032: 7172 7374 7576 7778 597a 2074 7970 65    qrstuvwxYz type

        We can see that:

         - Nibble 4 is 0x6 in file1.txt; 0x4 in file2.txt

         - Nibble 14 is 0x4 in file1.txt; 0x6 in file2.txt

         - Nibble 24 is 0x6 in file1.txt; 0x4 in file2.txt

         - Nibble 34 is 0x5 in file1.txt; 0x7 in file2.txt

         - Nibble 48 is 0x7 in file1.txt; 0x5 in file2.txt

         - Nibble 56 is 0x6 in file1.txt; 0x7 in file2.txt

         - Nibble 57 is 0x5 in file1.txt; 0x9 in file2.txt

         - Nibble 59 is 0x8 in file1.txt; 0x0 in file2.txt

         - Nibble 60 is 0x7 in file1.txt; 0x6 in file2.txt

         - Nibble 61 is 0x4 in file1.txt; 0x5 in file2.txt

        ----------------------------------------------------------------------
        Performing a bit-by-bit comparision with '-c=b' and '-m':

            \$ $0 -c=b -m file1.txt file2.txt
            0:1:0:1:0:1:1:0:0:0:1

        We can see the basis for this output by examining the bitdump of 
        file1.txt:

            Bit Offset (in decimal)
            |
            |    Bit Values
            |    |
            000: 01100001 01100010 01100011 01100100 01100101 01100110  abcdef
            048: 01100111 01001000 01101001 01101010 01101011 01101100  gHijkl
            096: 01101101 01101110 01101111 01110000 01110001 01010010  mnopqR
            144: 01110011 01110100 01110101 01110110 01110111 01111000  stuvwx
            192: 01111001 01111010 00100000 01110100 01100101 01111000  yz tex
            240: 01110100                                               t

        And the bitdump of file2.txt:

            Bit Offset (in decimal)
            |
            |    Bit Values
            |    |
            000: 01100001 01100010 01000011 01100100 01100101 01100110  abCdef
            048: 01100111 01101000 01101001 01101010 01101011 01101100  ghijkl
            096: 01001101 01101110 01101111 01110000 01110001 01110010  Mnopqr
            144: 01110011 01110100 01110101 01110110 01110111 01111000  stuvwx
            192: 01011001 01111010 00100000 01110100 01111001 01110000  Yz typ
            240: 01100101                                               e

        We can see that:

         - Bit 18 is 1 in file1.txt; 0 in file2.txt

         - Bit 58 is 0 in file1.txt; 1 in file2.txt

         - Bit 98 is 1 in file1.txt; 0 in file2.txt

         - Bit 146 is 0 in file1.txt; 1 in file2.txt

         - Bit 194 is 1 in file1.txt; 0 in file2.txt

         - Bit 227 is 0 in file1.txt; 1 in file2.txt

         - Bit 228 is 0 in file1.txt; 1 in file2.txt

         - Bit 229 is 1 in file1.txt; 0 in file2.txt

         - Bit 236 is 1 in file1.txt; 0 in file2.txt

         - Bit 243 is 1 in file1.txt; 0 in file2.txt

         - Bit 247 is 0 in file1.txt; 1 in file2.txt

        Default: Enabled.

    -o  Display the data from <file1> that are different from the data in
        <file2>.

        For example, with files:

            -----start: file1.txt-----
            abcdefgHijklmnopqRstuvwxyz text
            -----end: file1.txt-----

            -----start: file2.txt-----
            abCdefghijklMnopqrstuvwxYz type
            -----end: file2.txt-----

        Performing a byte-by-byte comparision with '-c=B' and '-o':

            \$ $0 -c=B -o file1.txt file2.txt
            63:48:6d:52:79:65:78:74

        We can see the basis for this output by examining the hexdump of
        file1.txt:

            Byte Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 6364 6566 6748 696a 6b6c 6d6e 6f70  abcdefgHijklmnop
            016: 7152 7374 7576 7778 797a 2074 6578 74    qRstuvwxyz text

        And the hexdump of file2.txt:

            Byte Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 4364 6566 6768 696a 6b6c 4d6e 6f70  abCdefghijklMnop
            016: 7172 7374 7576 7778 597a 2074 7970 65    qrstuvwxYz type

        We can see that:

         - Byte 2 is 0x63 ('c') in file1.txt; 0x43 ('C') in file2.txt

         - Byte 7 is 0x48 ('H') in file1.txt; 0x68 ('h') in file2.txt

         - Byte 12 is 0x6d ('m') in file1.txt; 0x4d ('M') in file2.txt

         - Byte 17 is 0x52 ('R') in file1.txt; 0x72 ('r') in file2.txt

         - Byte 24 is 0x79 ('y') in file1.txt; 0x59 ('Y') in file2.txt

         - Byte 28 is 0x65 ('e') in file1.txt; 0x79 ('y') in file2.txt

         - Byte 29 is 0x78 ('x') in file1.txt; 0x70 ('p') in file2.txt

         - Byte 30 is 0x74 ('t') in file1.txt; 0x65 ('e') in file2.txt

        ----------------------------------------------------------------------
        Performing a nibble-by-nibble comparision with '-c=n' and '-o':

            \$ $0 -c=n -o file1.txt file2.txt
            6:4:6:5:7:6:5:8:7:4

        Once again, we can see the basis for this output by examining the
        hexdump of file1.txt:

            Nibble Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 6364 6566 6748 696a 6b6c 6d6e 6f70  abcdefgHijklmnop
            032: 7152 7374 7576 7778 797a 2074 6578 74    qRstuvwxyz text

        And the hexdump of file2.txt:

            Nibble Offset (in decimal)
            |
            |    Hex Values
            |    |
            000: 6162 4364 6566 6768 696a 6b6c 4d6e 6f70  abCdefghijklMnop
            032: 7172 7374 7576 7778 597a 2074 7970 65    qrstuvwxYz type

        We can see that:

         - Nibble 4 is 0x6 in file1.txt; 0x4 in file2.txt

         - Nibble 14 is 0x4 in file1.txt; 0x6 in file2.txt

         - Nibble 24 is 0x6 in file1.txt; 0x4 in file2.txt

         - Nibble 34 is 0x5 in file1.txt; 0x7 in file2.txt

         - Nibble 48 is 0x7 in file1.txt; 0x5 in file2.txt

         - Nibble 56 is 0x6 in file1.txt; 0x7 in file2.txt

         - Nibble 57 is 0x5 in file1.txt; 0x9 in file2.txt

         - Nibble 59 is 0x8 in file1.txt; 0x0 in file2.txt

         - Nibble 60 is 0x7 in file1.txt; 0x6 in file2.txt

         - Nibble 61 is 0x4 in file1.txt; 0x5 in file2.txt

        ----------------------------------------------------------------------
        Performing a bit-by-bit comparision with '-c=b' and '-o':

            \$ $0 -c=b -o file1.txt file2.txt
            1:0:1:0:1:0:0:1:1:1:0

        We can see the basis for this output by examining the bitdump of 
        file1.txt:

            Bit Offset (in decimal)
            |
            |    Bit Values
            |    |
            000: 01100001 01100010 01100011 01100100 01100101 01100110  abcdef
            048: 01100111 01001000 01101001 01101010 01101011 01101100  gHijkl
            096: 01101101 01101110 01101111 01110000 01110001 01010010  mnopqR
            144: 01110011 01110100 01110101 01110110 01110111 01111000  stuvwx
            192: 01111001 01111010 00100000 01110100 01100101 01111000  yz tex
            240: 01110100                                               t

        And the bitdump of file2.txt:

            Bit Offset (in decimal)
            |
            |    Bit Values
            |    |
            000: 01100001 01100010 01000011 01100100 01100101 01100110  abCdef
            048: 01100111 01101000 01101001 01101010 01101011 01101100  ghijkl
            096: 01001101 01101110 01101111 01110000 01110001 01110010  Mnopqr
            144: 01110011 01110100 01110101 01110110 01110111 01111000  stuvwx
            192: 01011001 01111010 00100000 01110100 01111001 01110000  Yz typ
            240: 01100101                                               e

        We can see that:

         - Bit 18 is 1 in file1.txt; 0 in file2.txt

         - Bit 58 is 0 in file1.txt; 1 in file2.txt

         - Bit 98 is 1 in file1.txt; 0 in file2.txt

         - Bit 138 is 0 in file1.txt; 1 in file2.txt

         - Bit 194 is 1 in file1.txt; 0 in file2.txt

         - Bit 227 is 0 in file1.txt; 1 in file2.txt

         - Bit 228 is 0 in file1.txt; 1 in file2.txt

         - Bit 229 is 1 in file1.txt; 0 in file2.txt

         - Bit 236 is 1 in file1.txt; 0 in file2.txt

         - Bit 243 is 1 in file1.txt; 0 in file2.txt

         - Bit 247 is 0 in file1.txt; 1 in file2.txt

        Default: Disabled.

COMBINING OUTPUT OPTIONS

    -b with -c=b

        The '-b' option can be used in combination with the '-c=b' option.
        However, it doesn't really have any effect since '-c=b' output is
        already in binary.

    -b with -c=n, -c=B

        The '-b' option can be used in combination with either the '-c=n' or
        '-c=B' option.

    -c=b, -c=n, -c=B

        The '-c=b', '-c=n', and '-c=B' options cannot be used together in any
        combination.

    -c=b with -m, -o

        The '-c=b' option can be used in combination with one or both of the
        '-m' and '-o' options.

        In all cases, the output will be displayed as binary characters
        (i.e., 0 or 1).

    -c=B with -m, -o

        The '-c=B' option can be used in combination with one or both of the
        '-m' and '-o' options.

    -c=n with -m, -o

        The '-c=n' option can be used in combination with one or both of the
        '-m' and '-o' options.

    -m with -o

        The output from the '-o' option could be easily produced by reversing
        the order of the files on the command line.  For example, the output
        of:

            $0 -o file1 file2

        Is the same as the output of:

            $0 -m file2 file1

        The value of having both a '-m' and '-o' option is that both the
        original and modified content can be extracted with one execution of
        the script.  This can be useful when comparing large files.

        When the '-m' and '-o' options are used together, the output will be a
        string of colon-delimited character groups, where each group of
        characters is a comma-delimited list of the data from the modified
        <file2> and the data from the original <file1>.

        For example, given the following commands and output:

            \$ $0 -m -c=B file1 file2
            43:68:4d:72:59:79:70:65

            \$ $0 -o -c=B file1 file2
            63:48:6d:52:79:65:78:74

        We could instead run the following command:

            \$ $0 -m -o -c=B file1 file2
            43,63:68,48:4d,6d:72,52:59,79:79,65:70,78:65,74

        Similarly:

            \$ $0 -m -c=n file1 file2
            4:6:4:7:5:7:9:0:6:5

            \$ $0 -o -c=n file1 file2
            6:4:6:5:7:6:5:8:7:4

            \$ $0 -m -o -c=n file1 file2
            4,6:6,4:4,6:7,5:5,7:7,6:9,5:0,8:6,7:5,4

        And (although this combination has limited utility since a
        bit-by-bit comparison's '-m' and '-o' output will always be the
        inverse of one another):

            \$ $0 -m -c=b file1.txt file2.txt
            0:1:0:1:0:1:1:0:0:0:1

            \$ $0 -o -c=b file1.txt file2.txt
            1:0:1:0:1:0:0:1:1:1:0

            \$ $0 -m -o -c=b file1.txt file2.txt
            0,1:1,0:0,1:1,0:0,1:1,0:1,0:0,1:0,1:0,1:1,0

MANIPULATING OUTPUT

    There are many options that could be added to this script to control or
    filter output.  I've avoided adding options for functionality that could
    be easily accomplished with existing shell features or common tools.  A
    few common examples are listed here.

    REMOVING DELIMETERS

        The delimiters in the output can be removed multiple ways.  One of the
        easiest is to use the 'tr' command:

            # original output
            \$ $0 -m -c=B file1 file2
            43:68:4d:72:59:79:70:65

            # output without colon delimiter
            \$ $0 -m -c=B file1 file2 | tr -d ':'
            43684d7259797065

            # original output
            \$ $0 -m -o -c=b file3 file4
            0,1:1,0:0,1:1,0:0,1:1,0:1,0:0,1:0,1:0,1:1,0

            # output without comma delimiter
            \$ $0 -m -o -c=b file3 file4 | tr -d ','
            01:10:01:10:01:10:10:01:01:01:10

            # output without colon or comma delimiter
            \$ $0 -m -o -c=b file3 file4 | tr -d ',' | tr -d ':'
            0110011001101001010110

    GROUPING OUTPUT

        We might want to group the output for readability.

        For example, displaying hexadecimal characters in groups of four:

            # original output
            \$ $0 -m -c=B file1 file2
            43:68:4d:72:59:79:70:65

            # output with four character grouping, using 'fold'
            \$ $0 -m -c=B file1 file2 | tr -d ':' | fold -w 4 | tr '\\n' ' ' | sed 's/ $/\\n/'
            4368 4d72 5979 7065

            # output with four character grouping, using 'grep'
            \$ $0 -m -c=B file1 file2 | tr -d ':' | grep -Po ".{1,4}" | tr '\\n' ' ' | sed 's/ $/\\n/'
            4368 4d72 5979 7065

        Displaying binary characters in groups of eight:

            # original output
            \$ $0 -m -c=b file1 file2
            0:1:0:1:0:1:1:0:0:0:1

            # output with eight character grouping, using 'fold'
            \$ $0 -m -c=b file1 file2 | tr -d ':' | fold -w 8 | tr '\\n' ' ' | sed 's/ $/\\n/'
            01010110 001

            # output with eight character grouping, using 'grep'
            \$ $0 -m -c=b file1 file2 | tr -d ':' | grep -Po ".{1,8}" | tr '\\n' ' ' | sed 's/ $/\\n/'
            01010110 001

            # output with eight character grouping, omitting final group
            # of less than eight characters
            \$ $0 -m -c=b file1 file2 | tr -d ':' | grep -Po ".{8}" | tr '\\n' ' ' | sed 's/ $/\\n/'
            01010110

    CONVERTING BINARY TO HEXADECIMAL

        We might want to convert binary output to hexadecimal characters.  The
        easiest method would be to use a tool like 'bc':

            # original output without colon delimeter
            \$ $0 -m -c=b file1 file2 | tr -d ':'
            01110100011001010111100001110100

            \$ echo "obase=16; ibase=2; 01110100011001010111100001110100" | bc
            74657874 

        Note that the 'bc' command doesn't print leading 0 characters.

        Another option is to use the 'printf' command:

            # convert binary to hexadecimal
            \$ printf '%x\\n' "\$((2#01110100011001010111100001110100))"
            74657874 

        Note that the 'printf' command will only work with numbers up to 64
        bits in length.  If we had a binary number longer than 64 bits then
        we'd need to split it up into strings no longer than 64 characters:

            # split up the binary text into multiple strings, no longer than
            # 64 characters each
            \$ echo 01101100011011110110111001100111001000000111010001100101011110000111010000001010 | grep -Po ".{1,64}"
            0110110001101111011011100110011100100000011101000110010101111000
            0111010000001010

            # convert each binary string individually
            \$ printf '%x' "\$((2#0110110001101111011011100110011100100000011101000110010101111000))"; printf '%x\\n' "\$((2#0111010000001010))"
            6c6f6e6720746578740a

    CONVERTING HEXADECIMAL TO BINARY

        We might want to initially produce hexadecimal output and then convert
        to binary.  The easiest method would be to use a tool like 'bc':

            # original output without colon delimiter
            \$ $0 -m -c=B file1 file2 | tr -d ':'
            74657874

            # convert hexadecimal to binary
            \$ echo "obase=2; ibase=16; 74657874" | bc
            1110100011001010111100001110100

        Note that the 'bc' command doesn't print leading 0 characters.

        If we don't have 'bc' or something similar then we can use other tools
        to manipulate strings which we can then use with 'printf':

            # format the hexadecimal as input for printf
            \$ $0 -m -c=B file1 file2 | tr -d ':' | rev | grep -Po ".{2}" | sed 's/$/x\\\\/' | tr -d '\\n' | rev; echo
            \\x74\\x65\\x78\\x74

            # use printf to convert hexadecimal to binary
            \$ printf '\\x74\\x65\\x78\\x74' | xxd -g 0 -b | cut -d ' ' -f 2 | tr -d '\\n'; echo
            01110100011001010111100001110100

        Assuming the hexadecimal is an even number of characters, we could use
        multiple rounds of 'xxd' to convert to binary:

            # use xxd to convert hexadecimal to binary
            \$ echo 74657874 | xxd -r -p | xxd -g 0 -b | cut -d ' ' -f 2 | tr -d '\\n'; echo
            01110100011001010111100001110100

    CONVERTING HEXADECIMAL TO ASCII TEXT OR DATA

        The 'xxd' command can be used to convert hexadecimal characters to
        data - including to ASCII text if that's what the hexadecimal
        represents:

            # original output
            \$ $0 -m -c=B file1 file2
            74:65:78:74

            # convert hexadecimal to ASCII text
            \$ $0 -m -c=B file1 file2 | tr -d ':' | xxd -r -p
            text

        Extracted data might represent some other type of content:

            # original output
            \$ $0 -m -c=B file1 file2
            1f:8b:08:00:13:3c:65:5e:00:03:2b:c9:c8:2c:56:00:a2:92:d4:8a:12:2e:00:c9:07:37:0b:0d:00:00:00

            # convert hexadecimal to data; save to a file
            \$ $0 -m -c=B file1 file2 | tr -d ':' | xxd -r -p > temp.data

            # check to see what kind of data this is
            \$ file temp.data
            temp.data: gzip compressed data, last modified: Sun Mar  8 18:40:19 2020, from Unix

            # uncompress the data
            \$ cat temp.data | gzip -d
            this is text

    EXTRACTING LEAST-SIGNIFICANT BITS

        It might be useful to extract one or more least-significant bits
        (LSBs) from output.

            # original output
            \$ $0 -m -c=B file1 file2
            43:68:4d:72

            # convert hexadecimal to binary
            \$ $0 -m -c=B file1 file2 | tr -d ':' | xxd -r -p | xxd -b -g 0 | cut -d ' ' -f 2
            01000011011010000100110101110010

            # display in eight-character groups so that the LSB(s) are more
            # obvious to the naked eye
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}"
            01000011
            01101000
            01001101
            01110010

            # pull out the LSBs from each group of eight bits
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 8
            1
            0
            1
            0

            # convert the extracted LSBs to hexadecimal (two steps)
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 8 | tr -d '\\n'; echo
            1010

            \$ printf '%x\\n' "\$((2#1010))"
            a

            # pull out two LSBs from each group of eight bits
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 7-8
            11
            00
            01
            10

            # convert the extracted LSBs to hexadecimal (two steps)
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 7-8 | tr -d '\\n'; echo
            11000110

            \$ printf '%x\\n' "\$((2#11000110))"
            c6

            # pull out three LSBs from each group of eight bits
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 6-8
            011
            000
            101
            010

            # convert the extracted LSBs to hexadecimal (two steps)
            \$ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 6-8 | tr -d '\\n'; echo
            011000101010

            \$ printf '%x\\n' "\$((2#011000101010))"
            62a

    SEPARATING MODIFIED AND ORIGINAL DATA

        When the '-m' and '-o' options are used together, the output will be a
        string of colon-delimited character groups, where each group of
        characters is a comma-delimited list of the data from the modified
        <file2> and the data from the original <file1>.  For example:

            \$ $0 -m -o -c=B file1.txt file2.txt
            43,63:68,48:4d,6d:72,52:59,79:79,65:70,78:65,74

        The value of having both a '-m' and '-o' option is both the original
        and modified content can be extracted with one execution of the
        script.  This can be useful when comparing large files.

        However, we might want to work with the modified and original content
        separately without needing to run the script multiple times.  The
        simplest method is to save the output of the script to a file and then
        work with that file:

            # redirect output to a text file
            \$ $0 -m -o -c=B file1.txt file2.txt > temp.txt

            # extract the modified data
            \$ cat temp.txt | tr ':' '\\n' | cut -d ',' -f 1 | tr '\\n' ':' | sed 's/:$/\\n/'
            43:68:4d:72:59:79:70:65

            # extract the original data
            \$ cat temp.txt | tr ':' '\\n' | cut -d ',' -f 2 | tr '\\n' ':' | sed 's/:$/\\n/'
            63:48:6d:52:79:65:78:74

    COMPARING FILES OF DIFFERENT SIZES

        This script allows files of different sizes to be compared, but only
        compares data up to the size of the smaller file.

        It might be useful to look at the data in the larger file.  One way to
        do this is with the 'tail' command.  For example, suppose we have two
        files:
  
            -----start: file1.txt-----
            abcdefgHijklmnopqRstuvwxyz text
            -----end: file1.txt-----
 
            -----start: file2.txt-----
            abcdefgHijklmnopqRstuvwxyz type-this is extra content
            -----end: file2.txt-----

        When we run the script we'll get the expected output (to STDOUT) but
        also a warning message (to STDERR):

            \$ $0 -m -c=B file1.txt file2.txt
            $0: The original file <file1> is smaller than the modified file <file2>.
            43:68:4d:72:59:79:70:65:2d

        We can get the file sizes of each file:

            \$ stat --printf='%s\n' file1.txt file2.txt
            32
            54

        Then we can extract the additional bytes from the second file:

            \$ tail -c \$((54-32+1)) file2.txt
            -this is extra content

        Or we could do that all on one command line:

            \$ tail -c \$((\`stat --printf='%s' file2.txt\`-\`stat --printf='%s' file1.txt\`+1)) file2.txt
            -this is extra content

EXAMPLE USE CASES

    This section provides examples to illustrate how this script might be put
    to practical use.  The data extracted in these examples is ASCII text but
    the same techniques can be put to use to extract data that then requires
    further manipulation (e.g., decoding, decompression).

    Some of these examples use techniques that could have been added as
    options to the script (e.g., pulling out the least-significant bits). As
    with the examples described under MANIPULATING OUTPUT, I've avoided adding
    options for functionality that could be implemented with existing shell
    features or common tools.

    TEXT FILE STEGONAGRAPHY - MODIFIED CHARACTERS

        We suspect that a message has been hidden inside of a text file by
        modifying some of the original characters; and that combining the
        modified characters will allow us to extract the message.  Fortunately
        we have a copy of the original text and can compare it to the modified
        text.  We want to quickly extract all of the modified characters and
        examine them.

            -----start: green1.txt-----
            I do not like them in a house.
            I do not like them with a mouse.
            I do not like them here or there.
            I do not like them anywhere.
            I do not like green eggs and ham.
            I do not like them, Sam-I-Am.
            -----end: green1.txt-----

            -----start: green2.txt-----
            I do not like theM in a housE.
            I do not likE Them_with a MousE.
            I_do not Like them here or there.
            I do not like them Anywhere.
            I do noT likE gReen eggs and ham.
            I do not like them, Sam-I-Am.
            -----end: green2.txt-----

        Let's perform a byte-by-byte comparision with '-m' and '-c=B':

            $0 -m -c=B green1.txt green2.txt
            4d:45:45:54:5f:4d:45:5f:4c:41:54:45:52

        Now we'd like to see if this represents readable ASCII text:

            $0  -m -c=B green1.txt green2.txt | tr -d ':' | xxd -r -p; echo
            MEET_ME_LATER

    BINARY FILE STEGONAGRAPHY - MODIFIED BITS

        We suspect that a message has been hidden inside of a binary file by
        modifying some of the original bits; and that combining the modified
        bits will allow us to extract the message.  Fortunately we have a copy
        of the original binary file and can compare it to the modified file.
        We want to quickly extract all of the modified bits and examine them.

            -----start: hexdump of okay_up.bmp-----
            424d a001 0000 0000 0000 4e00 0000 2800 0000 1900 0000 1500 0000
            0100 0400 0000 0000 0000 0000 120b 0000 120b 0000 0600 0000 0600
            0000 00ff 0000 ffff ff00 e7e7 e700 c6c6 c600 8484 8400 0000 0000
            5555 5555 5555 5555 5555 5555 5000 0000 1444 4444 4444 4444 4444
            4444 5000 5555 1233 3333 3333 3333 3333 3334 5000 1444 1233 3333
            3333 3333 3333 3334 5000 1233 1233 3333 3444 3333 3333 3334 5000
            1233 1233 3333 5554 4333 3333 3334 5000 1233 1233 3335 0005 4433
            3333 3334 5000 1233 1233 3330 0000 5443 3333 3334 5000 1233 1233
            3330 0000 0544 3333 3334 5000 1233 1233 3330 0000 0054 4333 3334
            5000 1233 1233 3330 0050 0005 4433 3334 5000 1233 1233 3330 0053
            0000 5433 3334 5000 1233 1233 3330 0053 3000 5443 3334 5000 1233
            1233 3333 0033 3300 0543 3334 5000 1233 1233 3333 3333 3330 0053
            3334 5000 1233 1233 3333 3333 3333 0003 3334 5000 1233 1233 3333
            3333 3333 3003 3334 5000 1233 1233 3333 3333 3333 3303 3334 5000
            1233 1233 3333 3333 3333 3333 3334 5000 1233 1222 2222 2222 2222
            2222 2224 5000 1233 1111 1111 1111 1111 1111 1111 5000 1222 0000
            -----end: hexdump of okay_up.bmp-----

            -----start: hexdump of okay_up-diff.bmp-----
            424d a001 0000 0000 0000 4e00 0000 2800 0000 1900 0000 1500 0000
            0100 0400 0000 0000 0000 0000 120b 0000 120b 0000 0600 0000 0600
            0000 00ff 0000 ffff ff00 e7e7 e700 c6c6 c600 8484 8400 0000 0000
            5555 5555 5555 5555 5555 5555 5000 0000 1444 4444 4444 4444 4444
            4444 5000 5555 1232 3732 3232 3232 3732 3734 5000 1444 1237 3732
            3732 3232 3237 3234 5000 1233 1232 3232 3444 3232 3732 3234 5000
            1233 1237 3737 5554 4332 3237 3734 5000 1233 1233 3335 0005 4432
            3737 3734 5000 1233 1237 3230 0000 5443 3737 3234 5000 1233 1237
            3730 0000 0544 3737 3334 5000 1233 1233 3330 0000 0054 4333 3334
            5000 1233 1233 3330 0050 0005 4433 3334 5000 1233 1233 3330 0053
            0000 5433 3334 5000 1233 1233 3330 0053 3000 5443 3334 5000 1233
            1233 3333 0033 3300 0543 3334 5000 1233 1233 3333 3333 3330 0053
            3334 5000 1233 1233 3333 3333 3333 0003 3334 5000 1233 1233 3333
            3333 3333 3003 3334 5000 1233 1233 3333 3333 3333 3303 3334 5000
            1233 1232 3737 3237 3737 3233 3334 5000 1233 1222 2222 2222 2222
            2222 2224 5000 1233 1111 1111 1111 1111 1111 1111 5000 1222 0000
            -----end: hexdump of okay_up-diff.bmp-----

        Let's perform a bit-by-bit comparision with '-m' and '-c=b':

            \$ $0 -m -c=b okay_up.bmp okay_up-diff.bmp
            0:1:0:0:0:0:0:1:0:1:1:1:0:1:0:0:0:0:1:0:0:0:0:0:0:1:0:0:1:1:1:0:0:1:1:0:1:1:1:1:0:1:1:0:1:1:1:1:0:1:1:0:1:1:1:0

        We can strip out the colon characters:

            \$ $0 -m -c=b okay_up.bmp okay_up-diff.bmp | tr -d ':'
            01000001011101000010000001001110011011110110111101101110

        Then convert that binary string to hexadecimal:

            \$ printf '%x\\n' "\$((2#01000001011101000010000001001110011011110110111101101110))"
            4174204e6f6f6e

        Finally, convert the hexadecimal to readable ASCII text:

            \$ echo 4174204e6f6f6e | xxd -r -p; echo
            At Noon

    BINARY FILE STEGONAGRAPHY - LEAST-SIGNIFICANT BITS (LSBs)

        We suspect that a message has been hidden inside of a binary file by
        modifying some of the original bytes; and that combining the least-
        significant bit of the modified bytes will allow us to extract the
        message.  Fortunately we have a copy of the original binary file and
        can compare it to the modified file.  We want to quickly extract all
        of the modified bits and examine them.

            -----start: hexdump of okay_up.bmp-----
            424d a001 0000 0000 0000 4e00 0000 2800 0000 1900 0000 1500 0000
            0100 0400 0000 0000 0000 0000 120b 0000 120b 0000 0600 0000 0600
            0000 00ff 0000 ffff ff00 e7e7 e700 c6c6 c600 8484 8400 0000 0000
            5555 5555 5555 5555 5555 5555 5000 0000 1444 4444 4444 4444 4444
            4444 5000 5555 1233 3333 3333 3333 3333 3334 5000 1444 1233 3333
            3333 3333 3333 3334 5000 1233 1233 3333 3444 3333 3333 3334 5000
            1233 1233 3333 5554 4333 3333 3334 5000 1233 1233 3335 0005 4433
            3333 3334 5000 1233 1233 3330 0000 5443 3333 3334 5000 1233 1233
            3330 0000 0544 3333 3334 5000 1233 1233 3330 0000 0054 4333 3334
            5000 1233 1233 3330 0050 0005 4433 3334 5000 1233 1233 3330 0053
            0000 5433 3334 5000 1233 1233 3330 0053 3000 5443 3334 5000 1233
            1233 3333 0033 3300 0543 3334 5000 1233 1233 3333 3333 3330 0053
            3334 5000 1233 1233 3333 3333 3333 0003 3334 5000 1233 1233 3333
            3333 3333 3003 3334 5000 1233 1233 3333 3333 3333 3303 3334 5000
            1233 1233 3333 3333 3333 3333 3334 5000 1233 1222 2222 2222 2222
            2222 2224 5000 1233 1111 1111 1111 1111 1111 1111 5000 1222 0000
            -----end: hexdump of okay_up.bmp-----

            -----start: hexdump of okay_up-lsb.bmp-----
            424d a001 0000 0000 0000 4e00 0000 2800 0000 1900 0000 1500 0000
            0100 0400 0000 0000 0000 0000 120b 0000 120b 0000 0600 0000 0600
            0000 00ff 0000 ffff ff00 e7e7 e700 c6c6 c600 8484 8400 0000 0000
            5555 5555 5555 5555 5555 5555 5000 0000 1444 4444 4444 4444 4444
            4444 5000 5555 1232 3132 3232 3232 3132 3134 5000 1444 1231 3132
            3132 3232 3231 3234 5000 1233 1232 3232 3444 3232 3132 3134 5000
            1233 1232 3132 5554 4332 3231 3134 5000 1233 1232 3135 0005 4432
            3232 3234 5000 1233 1231 3130 0000 5443 3232 3134 5000 1233 1232
            3130 0000 0544 3232 3134 5000 1233 1232 3230 0000 0054 4332 3234
            5000 1233 1232 3230 0050 0005 4431 3234 5000 1233 1231 3230 0053
            0000 5432 3134 5000 1233 1231 3230 0053 3000 5443 3334 5000 1233
            1231 3131 0032 3100 0543 3334 5000 1233 1232 3232 3131 3230 0053
            3334 5000 1233 1231 3131 3132 3131 0003 3334 5000 1233 1231 3232
            3132 3231 3003 3334 5000 1233 1231 3232 3132 3133 3303 3334 5000
            1233 1233 3333 3333 3333 3333 3334 5000 1233 1222 2222 2222 2222
            2222 2224 5000 1233 1111 1111 1111 1111 1111 1111 5000 1222 0000
            -----end: hexdump of okay_up-lsb.bmp-----

        Let's perform a byte-by-byte comparison with '-m' and '-c=B':

            \$ $0 -m -c=B okay_up.bmp okay_up-lsb.bmp 
            32:31:32:32:32:32:32:31:32:31:31:31:32:31:32:32:32:32:31:32:32:32:32:32:32:31:32:31:32:31:32:32:32:31:31:32:31:32:32:32:32:31:31:32:32:31:32:31:32:32:31:32:32:32:32:32:32:31:32:31:32:32:31:31:32:31:31:31:32:31:32:32:32:31:31:32:31:31:31:31:32:31:31:31:32:32:31:32:32:31:31:32:32:31:32:31

        Let's perform the same byte-by-byte comparison but output as binary:

            \$ $0 -m -c=B -b okay_up.bmp okay_up-lsb.bmp 
            001100100011000100110010001100100011001000110010001100100011000100110010001100010011000100110001001100100011000100110010001100100011001000110010001100010011001000110010001100100011001000110010001100100011000100110010001100010011001000110001001100100011001000110010001100010011000100110010001100010011001000110010001100100011001000110001001100010011001000110010001100010011001000110001001100100011001000110001001100100011001000110010001100100011001000110010001100010011001000110001001100100011001000110001001100010011001000110001001100010011000100110010001100010011001000110010001100100011000100110001001100100011000100110001001100010011000100110010001100010011000100110001001100100011001000110001001100100011001000110001001100010011001000110010001100010011001000110001

        Let's build on that to grab the LSB from every byte (i.e., grab every
        eighth bit):

            \$ $0 -m -c=B -b okay_up.bmp okay_up-lsb.bmp | tr -d ':' | grep -Po ".{8}" | cut -c 8 | tr -d '\n'; echo
            010000010111010000100000010101000110100001100101001000000101001101110100011011110111001001100101

        Now we want to convert that binary string to hexadecimal:

            \$ echo "obase=16; ibase=2; 010000010111010000100000010101000110100001100101001000000101001101110100011011110111001001100101" | bc
            4174205468652053746f7265

        Finally, convert the hexadecimal to readable ASCII text:

            \$ echo 4174205468652053746f7265 | xxd -r -p; echo
            At The Store

EXTERNAL DEPENDENCIES

    'cut' command

    'echo' command

    'paste' command

    'xxd' command

VERSION

    2020.03.07-01

        Original script.

    2020.03.18-01

        - Updated command-line options to use '-c=' instead of '-b', '-n'
          '-c'

        - Added '-b' option to display nibble-by-nibble and byte-by-byte
          comparison output in binary

        - Updated display_help () to match new options and clarify a few
          items, including demonstrating use of 'xxd -r -p | xxd -b' to
          convert hexadecimal to binary

        - Created display_diff () subroutine to minimize repeated code

        - Moved the 'paste' command to the top of the while loop (vs. the
          bottom), getting rid of the bash here string (side effect is
          that a comparison between identical files generates a blank
          line of output)

AUTHOR

    Greg Scheidel

EOF
}


#=============================================================================
# display_diff () 
#-----------------------------------------------------------------------------
# Passed a string that represents the difference between the two files,
# display that string either as-is or after converting to binary.
#
# The string passed to here will either be one binary character (from a
# bit-by-bit comparison), one hex character (from a nibble-by-nibble
# comparison), or two hex characters (from a byte-by-byte comparison).
#
# Print as-is if:
#
#  - this is one binary character
#
#  - this is one or two hex characters and we're not supposed to display the
#    output in binary
#
# Print after conversion to binary if:
#
#  - this is one or two hex characters and we're supposed to display the
#    output in binary
#
# The only reason we have a function for this is because the above steps are
# done once when displaying data from the modified file, and once when
# displaying data from the original file; it seems silly to write that code
# out twice.
# 
#-----------------------------------------------------------------------------
# Arguments
#
#  $1   String to display (either as-is or after conversion to binary)
# 
#-----------------------------------------------------------------------------
# Local Variables
#
# None
# 
#-----------------------------------------------------------------------------
# Global Variables Referenced
#
# _binary
#
# _byte
#-----------------------------------------------------------------------------
display_diff () {
    # if we're converting to binary (which means that we're
    # performing a nibble-by-nibble or byte-by-byte comparison)
    # then... well, convert to binary.
    if [ $_binary -eq 1 ]; then

        # convert a byte (i.e., two hex characters)
        if [ $_byte -eq 1 ]; then
            echo -n $1 | xxd -r -p | xxd -b -g 0 | cut -d ' ' -f 2 | tr -d '\n'

        # convert a nibble (i.e., one hex character); using 'xxd',
        # this requires padding the hex character with a '0',
        # running through 'xxd', then stripping out the extra
        # leading '0000'
        else
            echo -n 0$1 | xxd -r -p | xxd -b -g 0 | cut -d ' ' -f 2 | cut -c 5-8 | tr -d '\n'
        fi

    # if we're not converting to binary, then just display the string as-is
    else
        echo -n $1
    fi
}


#=============================================================================
# main 
#-----------------------------------------------------------------------------
# See display_help () for details.
#
#-----------------------------------------------------------------------------
# Variables
#
# _binary
#
#   Identify whether output should be binary for nibble-by-nibble and
#   byte-by-byte comparisons.
#
#   0 = output in hex
#   1 = output in binary
#
#   Default: 0 (output in hex)
#
# _bit
#
#   Identify whether we're going to perform a bit-by-bit comparison.
#
#   0 = no bit-by-bit comparison
#   1 = bit-by-bit comparison
#
#   Default: 0 (no bit-by-bit comparison)
#
# _byte
#
#   Identify whether we're going to perform a byte-by-byte comparison.
#
#   0 = no byte-by-byte comparison
#   1 = byte-by-byte comparison
#
#   Default: 1 (byte-by-byte comparison)
#
# _diff
#
#   Identifies whether a difference has been found between the two files.
#   Initially set to 0; if we do find a difference, then we'll change _diff to
#   1 so that after the comparisons we know to print a final LF.
#
#   0 = no difference found
#   1 = difference found
#
#   Default: 0 (no difference found)
#
# _file_1_line
#
#   Holds the line of content from the first file, to be compared with the
#   corresponding line of content from the second file.
#
# _file_2_line
#
#   Holds the line of content from the second file, to be compared with the
#   corresponding line of content from the first file.
#
# _group
#
#   Identify how many hexdump (or bitdump) characters to compare at a time;
#   and to display in each group within the colon-delimited and
#   comma-delimited output.
#
#   If performing a bit-by-bit or nibble-by-nibble comparison, then this will
#   be 1; if performing a byte-by-byte comparison, then this will be 2.
#
#   Default: 2 (because byte-by-byte comparison is the default)
#
# _mod
#
#   Identifies whether to display the modified values (from the second file).
#
#   0 = don't display modified values
#   1 = display original values
#
#   Default: 1 (modified values)
#
#       (Set after processing command-line  arguments to allow
#       differentiation between '-m' being assumed as the  default vs.
#       being explicitly specified.)
#
# _nibble
#
#   Identify whether we're going to perform a nibble-by-nibble comparison.
#
#   0 = no nibble-by-nibble comparison
#   1 = nibble-by-nibble comparison
#
#   Default: 0 (no nibble-by-nibble comparison)
#
# _orig
#
#   Identifies whether to display the original values (from the first file).
#
#   0 = don't display original values
#   1 = display original values
#
#   Default: 0 (modified values)
#
# _tempvar1
# _tempvar2
#
#   Temporary variables (e.g., counters, temp calculations).
#
# _xxd_args
#
#   Used to pass the '-b' argument to the 'xxd' commands if a bit-by-bit
#   comparison is being performed.  If a bit-by-bit comparison is *not* being
#   performed then this is set to '-g 0'; if a bit-by-bit comparision *is*
#   being performed then this is set to '-g 0 -b'.
#-----------------------------------------------------------------------------

# initialize variables
_bit=0
_binary=0
_byte=0
_diff=0
_file_1_line=
_file_2_line=
_group=0
_mod=0
_nibble=0
_orig=0
_tempvar1=0
_tempvar2=0
_xxd_args=

# Process command-line arguments left-to-right until we encounter an argument
# that isn't an option.  If an option is found, then process it, then shift
# the arguments one to the left (so that at the end $1 and $2 should refer to
# the files to compare).
while [ "${1:0:1}" == "-" ]; do
echo -n .
    case "$1" in

        # output in binary format (for nibble and byte comparisons)
        -b)
            _binary=1

            # shift arguments one to the left
            shift
            ;;

        # perform a bit-by-bit comparison
        -c=b)
            _bit=1

            # shift arguments one to the left
            shift
            ;;

        # perform a nibble-by-nibble comparison
        -c=n)
            _nibble=1

            # shift arguments one to the left
            shift
            ;;

        # perform a byte-by-byte comparison
        -c=B)
            _byte=1

            # shift arguments one to the left
            shift
            ;;

        # display usage and exit
        #
        # (yes, the '-?' option is undocumented in the help content)
        -h | -?)
            display_usage
            exit
            ;;

        # display modified data (from the second file)
        -m)
            _mod=1

            # shift arguments one to the left
            shift
            ;;

        # display original data (from the first file)
        -o)
            _orig=1

            # shift arguments one to the left
            shift
            ;;

        # unknown option
        *)
            echo $0: Unknown argument \'$1\'.>&2
            exit
    esac
done

# If more than one comparison type is specified, then error out.
if [ $(($_bit + $_nibble + $_byte)) -gt 1 ]; then
    echo $0: Only one comparison type can be specified.  Try '-h'.>&2
    exit
fi

# If no comparison type is specified, then assume byte-by-byte.
if [ $_bit -eq 0 -a $_nibble -eq 0 -a $_byte -eq 0 ]; then
    _byte=1
fi

# If neither '-m' nor '-o' were specified, assume '-m' (output data that is
# different in the modified file).
if [ $_mod -eq 0 -a $_orig -eq 0 ]; then
    _mod=1
fi

# Note: Not displaying an error or warning if '-b' is used in combination with
# bit-by-bit comparison.  Bit-by-bit comparisons already generate binary output, so who
# cares if the user unnecessarily specifies '-b'?
#
# However, we *are* going to clear the _binary value if we're doing a
# bit-by-bit comparison.  It makes the logic slightly cleaner when it comes to
# deciding whether to convert each character (or set of characters) to binary.
if [ $_bit -eq 1 ]; then
    _binary=0
fi

# If there aren't two arguments left, then error out.
if [ $# -ne 2 ]; then
    echo $0: An original file and modified file must be specified.  Try '-h'.>&2
    exit
fi

# If the original file doesn't exist, then error out.
if [ ! -e "$1" ]; then
    echo $0: The original \<file1\> \"$1\" does not exist.>&2
    exit
fi

# If the modified file doesn't exist, then error out.
if [ ! -e "$2" ]; then
    echo $0: The modified \<file2\> \"$2\" does not exist.>&2
    exit
fi

# If the file sizes for <file1> and <file2> aren't the same, then echo a
# warning (but continue).
_tempvar1=`stat --printf='%s' "$1"`
_tempvar2=`stat --printf='%s' "$2"`
if [ $_tempvar1 -gt $_tempvar2 ]; then
    echo $0: The original \<file1\> \"$1\" is larger than the modified \<file2\> \"$2\".>&2
elif [ $_tempvar1 -lt $_tempvar2 ]; then
    echo $0: The original \<file1\> \"$1\" is smaller than the modified \<file2\> \"$2\".>&2
fi

# If we're performing either a bit-by-bit or nibble-by-nibble comparison,
# then we want to examine the 'xxd' output one character at a time.
if [ $_bit -eq 1 -o $_nibble -eq 1 ]; then
    _group=1

# Otherwise, we're doing a byte-by-byte compairson and want to examine
# the 'xxd' output two characters at a time.
else
    _group=2
fi

# If we're performing a bit-by-bit comparison, then we need a '-b' option for
# the 'xxd' command-line.
if [ $_bit -eq 1 ]; then
    _xxd_args='-b'

# otherwise just '-g 0' for no grouping of hexdump or bit dump output
else
    _xxd_args='-g 0'
fi

# Read input one line at a time, assigning values to two variables.  We're
# we're generating the lines using 'xxd', 'cut', and 'paste'; so we know
# that each line is space-delimited with two text strings, where the first
# string is the binary or hex representation of content from the first file
# and the second string is the binary or hex representation of content from
# the second file.
#
# - Using 'xxd' to obtain the hexdump of each of the files.
#
# - The 'cut' command grabs the hexadecimal or binary content and throws away
#   the rest of the 'xxd' output.
#
# - The 'xxd -g 0' is so that we don't have spaces in the middle of the
#   hexadecimal or binary numbers.  This makes the 'cut' command syntax
#   marginally simpler.
#
# - The 'paste' command accepts two file names as arguments.  Here we're
#   feeding 'paste' two file handles created with input redirection.
#
# - The 'paste' command takes the first line of output from the first 'xxd'
#   and concatenates it to the first line of output from the second 'xxd',
#   separated by a space; then the second lines of output, then the third
#   lines of output, etc.
#
# - The _xxd_args variable will contain either '-g 0' or '-b'.  The
#   '-g 0' specifies no grouping of the hex or binary output; the '-b'
#   specifies generating binary output (for when we're doing a bit-by-bit
#   comparison).
#
#   We already specifically use '-g 0' on the 'xxd' command line; having it
#   twice in the same command-line doesn't cause a problem and makes the
#   command-line kung-fu marginally simpler.

paste -d ' ' <(xxd "$_xxd_args" -g 0 "$1" | cut -d ' ' -f 2) <(xxd "$_xxd_args" -g 0 "$2" | cut -d ' ' -f 2) | while IFS=' ' read -r _file_1_line _file_2_line ; do

    # Get the length of each string, and then the min of those two; only
    # compare the strings up to that length.  If the files aren't the same
    # length and we're processing the last line of the smallest file, then
    # this will keep us from trying to compare past the end of the smallest
    # file.
    _tempvar1=${#_file_1_line}
    _tempvar2=${#_file_2_line}

    if [ $_tempvar1 -lt $_tempvar2 ]; then
        # tempvar2 will now be "length of the shortest string"
        _tempvar2=$_tempvar1
    fi

    # If the min string length is 0 then:
    #
    #  - one of the files is smaller than the other
    #
    #  - the amount of data in the smaller file is evenly divisible by the
    #    amount of data represented by each line of 'xxd' output
    #
    #  - the lines of 'xxd' output we read (and compared) in the last
    #    iteration of this 'while' loop contained the last data from the
    #    smaller of the two files.
    #
    # Which means that we should just exit now.
    if [ $_tempvar2 -eq 0 ]; then
        break
    fi

    # Loop through the contents of the first string (_file_1_line), one group
    # of characters at a time.
    #
    # tempvar1 will now be the loopvar identifying the offset (within the
    # string) of the character we're examining.
    for ((_tempvar1=0;_tempvar1<$_tempvar2;_tempvar1+=$_group)); do

        # For each group of characters, compare to the corresponding
        # characters of the second string.  If there is any difference, then
        # echo those characters and set the _diff variable to note that at
        # least one difference was found.
        if [ ${_file_1_line:$_tempvar1:$_group} != ${_file_2_line:$_tempvar1:$_group} ]; then

            # If we previously echoed some characters, then echo a colon
            # character as a separator between the previous group and this new
            # group.
            if [ $_diff -eq 1 ]; then
               echo -n :
            fi

            # echo the characters from the modified file?
            if [ $_mod -eq 1 ]; then
                display_diff ${_file_2_line:$_tempvar1:$_group}
            fi

            # echo the characters from the original file?
            if [ $_orig -eq 1 ]; then

                # If we also echoed (just a few lines ago) the characters from
                # the modified file, then echo a comma as a field separator.
                if [ $_mod -eq 1 ]; then
                   echo -n ,
                fi

                display_diff ${_file_1_line:$_tempvar1:$_group}
            fi

            # flag that we've found a difference, which is to say that we've
            # echoed some output; checked in subsequent iterations of the loop
            # to determine whether a ':' separator needs to be echoed
            _diff=1
        fi
    done
done

# echo a final newline; this does mean that a blank newline will be displayed
# when there are no differences between the two files
echo
