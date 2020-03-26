# hexdiff.sh

During the beta test for [Cyber Defense NetWars](https://www.sans.org/netwars/cyber-defense) (CDNW) v2, [Ryan Nicholson](https://www.sans.org/instructors/ryan-nicholson) and I were exchanging messages about a possible question to use in the game.  The question related to the use of steganography to hide messages in a binary file. Ryan commented that he thought the question might be harder to solve - and so worth more points - because there isn't a readily available tool to "carve" the message out of the binary file. In other words, he wasn't aware of a tool that would quickly look for the mangled bits and bytes in files and extract them for further analysis.

This bugged me because the solve itself was fairly straightforward - just slightly tedious because of that 'missing' tool.  So I wrote a quick bash script (yes, I know... someday I'll default to Python and Powershell instead of bash, Perl, and CMD) to compare two files (binary or text) and extract the bits that are different in one file or the other.

The core code for the actual comparison and extraction is ~40 lines long; the total code with command-line argument checking etc. is ~120 lines long; and the overall script with comments and help content is about ~1500 lines (because that's how I roll) and includes:

 - Examples of running the script to extract changed bits, nibbles, or bytes.
 
 - Examples of running the script to extract original bits, nibbles, or bytes.
 
 - Explanations of what the script is actually doing to extract changed or original bits, nibbles, and bytes.
 
 - Tips on manipulating the script output using other commands:
 
    - Removing delimiters from the output.
    
    - Grouping output for readability.
    
    - Converting binary output to hexadecimal.
    
    - Converting hexadecimal output to binary.
 
 - Tips on performing basic analysis on extracted content including:
 
    - Conversion of the extracted content to ASCII text or binary content.
    
    - Least-significant bit (LSB) analysis to extract hidden content.
    
 - Tips on extracting or examining extra bytes from one of the two files, when one file is larger than the other.
 
 - Example use cases:
 
    - Text file stegonagraphy, where characters are modified from an original file.
    
    - Binary file stegonagraphy, where bits are modified from an original file.
    
    - Binary file stegonagraphy, where LSBs are modified from an original file.

You can [retrieve the script here](http://www.scheidel.net/files/hexdiff.sh): [http://www.scheidel.net/files/hexdiff.sh]()

## Help Contents

Here's a copy of the help contents that are displayed when running the script with the `-h` command-line argument.

```
SYNOPSIS

    ./hexdiff.sh -h
    ./hexdiff.sh [-c=b|n|B] [-b] [-m] [-o] <file1> <file2>

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

            $ ./hexdiff.sh -c=B -m file1.txt file2.txt
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

            $ ./hexdiff.sh -c=n -m file1.txt file2.txt
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

            $ ./hexdiff.sh -c=b -m file1.txt file2.txt
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

            $ ./hexdiff.sh -c=B -o file1.txt file2.txt
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

            $ ./hexdiff.sh -c=n -o file1.txt file2.txt
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

            $ ./hexdiff.sh -c=b -o file1.txt file2.txt
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

            ./hexdiff.sh -o file1 file2

        Is the same as the output of:

            ./hexdiff.sh -m file2 file1

        The value of having both a '-m' and '-o' option is that both the
        original and modified content can be extracted with one execution of
        the script.  This can be useful when comparing large files.

        When the '-m' and '-o' options are used together, the output will be a
        string of colon-delimited character groups, where each group of
        characters is a comma-delimited list of the data from the modified
        <file2> and the data from the original <file1>.

        For example, given the following commands and output:

            $ ./hexdiff.sh -m -c=B file1 file2
            43:68:4d:72:59:79:70:65

            $ ./hexdiff.sh -o -c=B file1 file2
            63:48:6d:52:79:65:78:74

        We could instead run the following command:

            $ ./hexdiff.sh -m -o -c=B file1 file2
            43,63:68,48:4d,6d:72,52:59,79:79,65:70,78:65,74

        Similarly:

            $ ./hexdiff.sh -m -c=n file1 file2
            4:6:4:7:5:7:9:0:6:5

            $ ./hexdiff.sh -o -c=n file1 file2
            6:4:6:5:7:6:5:8:7:4

            $ ./hexdiff.sh -m -o -c=n file1 file2
            4,6:6,4:4,6:7,5:5,7:7,6:9,5:0,8:6,7:5,4

        And (although this combination has limited utility since a
        bit-by-bit comparison's '-m' and '-o' output will always be the
        inverse of one another):

            $ ./hexdiff.sh -m -c=b file1.txt file2.txt
            0:1:0:1:0:1:1:0:0:0:1

            $ ./hexdiff.sh -o -c=b file1.txt file2.txt
            1:0:1:0:1:0:0:1:1:1:0

            $ ./hexdiff.sh -m -o -c=b file1.txt file2.txt
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
            $ ./hexdiff.sh -m -c=B file1 file2
            43:68:4d:72:59:79:70:65

            # output without colon delimiter
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':'
            43684d7259797065

            # original output
            $ ./hexdiff.sh -m -o -c=b file3 file4
            0,1:1,0:0,1:1,0:0,1:1,0:1,0:0,1:0,1:0,1:1,0

            # output without comma delimiter
            $ ./hexdiff.sh -m -o -c=b file3 file4 | tr -d ','
            01:10:01:10:01:10:10:01:01:01:10

            # output without colon or comma delimiter
            $ ./hexdiff.sh -m -o -c=b file3 file4 | tr -d ',' | tr -d ':'
            0110011001101001010110

    GROUPING OUTPUT

        We might want to group the output for readability.

        For example, displaying hexadecimal characters in groups of four:

            # original output
            $ ./hexdiff.sh -m -c=B file1 file2
            43:68:4d:72:59:79:70:65

            # output with four character grouping, using 'fold'
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':' | fold -w 4 | tr '\n' ' ' | sed 's/ $/\n/'
            4368 4d72 5979 7065

            # output with four character grouping, using 'grep'
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':' | grep -Po ".{1,4}" | tr '\n' ' ' | sed 's/ $/\n/'
            4368 4d72 5979 7065

        Displaying binary characters in groups of eight:

            # original output
            $ ./hexdiff.sh -m -c=b file1 file2
            0:1:0:1:0:1:1:0:0:0:1

            # output with eight character grouping, using 'fold'
            $ ./hexdiff.sh -m -c=b file1 file2 | tr -d ':' | fold -w 8 | tr '\n' ' ' | sed 's/ $/\n/'
            01010110 001

            # output with eight character grouping, using 'grep'
            $ ./hexdiff.sh -m -c=b file1 file2 | tr -d ':' | grep -Po ".{1,8}" | tr '\n' ' ' | sed 's/ $/\n/'
            01010110 001

            # output with eight character grouping, omitting final group
            # of less than eight characters
            $ ./hexdiff.sh -m -c=b file1 file2 | tr -d ':' | grep -Po ".{8}" | tr '\n' ' ' | sed 's/ $/\n/'
            01010110

    CONVERTING BINARY TO HEXADECIMAL

        We might want to convert binary output to hexadecimal characters.  The
        easiest method would be to use a tool like 'bc':

            # original output without colon delimeter
            $ ./hexdiff.sh -m -c=b file1 file2 | tr -d ':'
            01110100011001010111100001110100

            $ echo "obase=16; ibase=2; 01110100011001010111100001110100" | bc
            74657874 

        Note that the 'bc' command doesn't print leading 0 characters.

        Another option is to use the 'printf' command:

            # convert binary to hexadecimal
            $ printf '%x\n' "$((2#01110100011001010111100001110100))"
            74657874 

        Note that the 'printf' command will only work with numbers up to 64
        bits in length.  If we had a binary number longer than 64 bits then
        we'd need to split it up into strings no longer than 64 characters:

            # split up the binary text into multiple strings, no longer than
            # 64 characters each
            $ echo 01101100011011110110111001100111001000000111010001100101011110000111010000001010 | grep -Po ".{1,64}"
            0110110001101111011011100110011100100000011101000110010101111000
            0111010000001010

            # convert each binary string individually
            $ printf '%x' "$((2#0110110001101111011011100110011100100000011101000110010101111000))"; printf '%x\n' "$((2#0111010000001010))"
            6c6f6e6720746578740a

    CONVERTING HEXADECIMAL TO BINARY

        We might want to initially produce hexadecimal output and then convert
        to binary.  The easiest method would be to use a tool like 'bc':

            # original output without colon delimiter
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':'
            74657874

            # convert hexadecimal to binary
            $ echo "obase=2; ibase=16; 74657874" | bc
            1110100011001010111100001110100

        Note that the 'bc' command doesn't print leading 0 characters.

        If we don't have 'bc' or something similar then we can use other tools
        to manipulate strings which we can then use with 'printf':

            # format the hexadecimal as input for printf
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':' | rev | grep -Po ".{2}" | sed 's/$/x\\/' | tr -d '\n' | rev; echo
            \x74\x65\x78\x74

            # use printf to convert hexadecimal to binary
            $ printf '\x74\x65\x78\x74' | xxd -g 0 -b | cut -d ' ' -f 2 | tr -d '\n'; echo
            01110100011001010111100001110100

        Assuming the hexadecimal is an even number of characters, we could use
        multiple rounds of 'xxd' to convert to binary:

            # use xxd to convert hexadecimal to binary
            $ echo 74657874 | xxd -r -p | xxd -g 0 -b | cut -d ' ' -f 2 | tr -d '\n'; echo
            01110100011001010111100001110100

    CONVERTING HEXADECIMAL TO ASCII TEXT OR DATA

        The 'xxd' command can be used to convert hexadecimal characters to
        data - including to ASCII text if that's what the hexadecimal
        represents:

            # original output
            $ ./hexdiff.sh -m -c=B file1 file2
            74:65:78:74

            # convert hexadecimal to ASCII text
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':' | xxd -r -p
            text

        Extracted data might represent some other type of content:

            # original output
            $ ./hexdiff.sh -m -c=B file1 file2
            1f:8b:08:00:13:3c:65:5e:00:03:2b:c9:c8:2c:56:00:a2:92:d4:8a:12:2e:00:c9:07:37:0b:0d:00:00:00

            # convert hexadecimal to data; save to a file
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':' | xxd -r -p > temp.data

            # check to see what kind of data this is
            $ file temp.data
            temp.data: gzip compressed data, last modified: Sun Mar  8 18:40:19 2020, from Unix

            # uncompress the data
            $ cat temp.data | gzip -d
            this is text

    EXTRACTING LEAST-SIGNIFICANT BITS

        It might be useful to extract one or more least-significant bits
        (LSBs) from output.

            # original output
            $ ./hexdiff.sh -m -c=B file1 file2
            43:68:4d:72

            # convert hexadecimal to binary
            $ ./hexdiff.sh -m -c=B file1 file2 | tr -d ':' | xxd -r -p | xxd -b -g 0 | cut -d ' ' -f 2
            01000011011010000100110101110010

            # display in eight-character groups so that the LSB(s) are more
            # obvious to the naked eye
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}"
            01000011
            01101000
            01001101
            01110010

            # pull out the LSBs from each group of eight bits
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 8
            1
            0
            1
            0

            # convert the extracted LSBs to hexadecimal (two steps)
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 8 | tr -d '\n'; echo
            1010

            $ printf '%x\n' "$((2#1010))"
            a

            # pull out two LSBs from each group of eight bits
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 7-8
            11
            00
            01
            10

            # convert the extracted LSBs to hexadecimal (two steps)
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 7-8 | tr -d '\n'; echo
            11000110

            $ printf '%x\n' "$((2#11000110))"
            c6

            # pull out three LSBs from each group of eight bits
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 6-8
            011
            000
            101
            010

            # convert the extracted LSBs to hexadecimal (two steps)
            $ echo 01000011011010000100110101110010 | grep -Po ".{8}" | cut -c 6-8 | tr -d '\n'; echo
            011000101010

            $ printf '%x\n' "$((2#011000101010))"
            62a

    SEPARATING MODIFIED AND ORIGINAL DATA

        When the '-m' and '-o' options are used together, the output will be a
        string of colon-delimited character groups, where each group of
        characters is a comma-delimited list of the data from the modified
        <file2> and the data from the original <file1>.  For example:

            $ ./hexdiff.sh -m -o -c=B file1.txt file2.txt
            43,63:68,48:4d,6d:72,52:59,79:79,65:70,78:65,74

        The value of having both a '-m' and '-o' option is both the original
        and modified content can be extracted with one execution of the
        script.  This can be useful when comparing large files.

        However, we might want to work with the modified and original content
        separately without needing to run the script multiple times.  The
        simplest method is to save the output of the script to a file and then
        work with that file:

            # redirect output to a text file
            $ ./hexdiff.sh -m -o -c=B file1.txt file2.txt > temp.txt

            # extract the modified data
            $ cat temp.txt | tr ':' '\n' | cut -d ',' -f 1 | tr '\n' ':' | sed 's/:$/\n/'
            43:68:4d:72:59:79:70:65

            # extract the original data
            $ cat temp.txt | tr ':' '\n' | cut -d ',' -f 2 | tr '\n' ':' | sed 's/:$/\n/'
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

            $ ./hexdiff.sh -m -c=B file1.txt file2.txt
            ./hexdiff.sh: The original file <file1> is smaller than the modified file <file2>.
            43:68:4d:72:59:79:70:65:2d

        We can get the file sizes of each file:

            $ stat --printf='%s\n' file1.txt file2.txt
            32
            54

        Then we can extract the additional bytes from the second file:

            $ tail -c $((54-32+1)) file2.txt
            -this is extra content

        Or we could do that all on one command line:

            $ tail -c $((`stat --printf='%s' file2.txt`-`stat --printf='%s' file1.txt`+1)) file2.txt
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

            ./hexdiff.sh -m -c=B green1.txt green2.txt
            4d:45:45:54:5f:4d:45:5f:4c:41:54:45:52

        Now we'd like to see if this represents readable ASCII text:

            ./hexdiff.sh  -m -c=B green1.txt green2.txt | tr -d ':' | xxd -r -p; echo
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

            $ ./hexdiff.sh -m -c=b okay_up.bmp okay_up-diff.bmp
            0:1:0:0:0:0:0:1:0:1:1:1:0:1:0:0:0:0:1:0:0:0:0:0:0:1:0:0:1:1:1:0:0:1:1:0:1:1:1:1:0:1:1:0:1:1:1:1:0:1:1:0:1:1:1:0

        We can strip out the colon characters:

            $ ./hexdiff.sh -m -c=b okay_up.bmp okay_up-diff.bmp | tr -d ':'
            01000001011101000010000001001110011011110110111101101110

        Then convert that binary string to hexadecimal:

            $ printf '%x\n' "$((2#01000001011101000010000001001110011011110110111101101110))"
            4174204e6f6f6e

        Finally, convert the hexadecimal to readable ASCII text:

            $ echo 4174204e6f6f6e | xxd -r -p; echo
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

            $ ./hexdiff.sh -m -c=B okay_up.bmp okay_up-lsb.bmp 
            32:31:32:32:32:32:32:31:32:31:31:31:32:31:32:32:32:32:31:32:32:32:32:32:32:31:32:31:32:31:32:32:32:31:31:32:31:32:32:32:32:31:31:32:32:31:32:31:32:32:31:32:32:32:32:32:32:31:32:31:32:32:31:31:32:31:31:31:32:31:32:32:32:31:31:32:31:31:31:31:32:31:31:31:32:32:31:32:32:31:31:32:32:31:32:31

        Let's perform the same byte-by-byte comparison but output as binary:

            $ ./hexdiff.sh -m -c=B -b okay_up.bmp okay_up-lsb.bmp 
            001100100011000100110010001100100011001000110010001100100011000100110010001100010011000100110001001100100011000100110010001100100011001000110010001100010011001000110010001100100011001000110010001100100011000100110010001100010011001000110001001100100011001000110010001100010011000100110010001100010011001000110010001100100011001000110001001100010011001000110010001100010011001000110001001100100011001000110001001100100011001000110010001100100011001000110010001100010011001000110001001100100011001000110001001100010011001000110001001100010011000100110010001100010011001000110010001100100011000100110001001100100011000100110001001100010011000100110010001100010011000100110001001100100011001000110001001100100011001000110001001100010011001000110010001100010011001000110001

        Let's build on that to grab the LSB from every byte (i.e., grab every
        eighth bit):

            $ ./hexdiff.sh -m -c=B -b okay_up.bmp okay_up-lsb.bmp | tr -d ':' | grep -Po ".{8}" | cut -c 8 | tr -d '\n'; echo
            010000010111010000100000010101000110100001100101001000000101001101110100011011110111001001100101

        Now we want to convert that binary string to hexadecimal:

            $ echo "obase=16; ibase=2; 010000010111010000100000010101000110100001100101001000000101001101110100011011110111001001100101" | bc
            4174205468652053746f7265

        Finally, convert the hexadecimal to readable ASCII text:

            $ echo 4174205468652053746f7265 | xxd -r -p; echo
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
```

## References

 1. [Cyber Defense NetWars](https://www.sans.org/netwars/cyber-defense) on sans.org
 
    [https://www.sans.org/netwars/cyber-defense]()
 
 2. [Ryan Nicholson](https://www.sans.org/instructors/ryan-nicholson) profile on sans.org
 
    [https://www.sans.org/instructors/ryan-nicholson]()

<hr class="tight">
Return to [Bash Scriptiong](http://www.scheidel.net/#!pages/scripting_and_programming/bash.md)

<hr class="tight"><p class="timestamp">Page updated >= 2020.03.26 00:32 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
