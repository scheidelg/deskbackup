# hexdiff.sh

During the beta test for [Cyber Defense NetWars](https://www.sans.org/netwars/cyber-defense) (CDNW) v2, [Ryan Nicholson](https://www.sans.org/instructors/ryan-nicholson) and I were exchanging messages about a candidate question.  The question related to the use of steganography to hide messages in a binary file. Ryan commented that he thought the question might be harder to solve - and so worth more points - because there isn't a readily available tool to "carve" the message out of the binary file. In other words, he wasn't aware of a tool that would quickly look for the mangled bits in text or binary files and extract them for further analysis.

This bugged me because the solve itself was fairly straightforward - just slightly tedious because it all had to be done by hand.  So I wrote a quick bash script (yes, I know... someday I'll default to Python and Powershell instead of bash, Perl, and CMD) to compare two files (binary or text) and extract the bits that are different in one file or the other.

The core code for the actual comparison and extraction is ~40 lines long; the total code with command-line argument checking etc. is ~120 lines long; and the overall script with comments and help content is about ~1500 lines (because that's how I roll) and includes examples of extracting changed bits, nibbles, or bytes and then performing basic analysis (including LSB) for hidden content.

You can see the actual script [here](http://www.scheidel.net/#!files/hexdiff.sh)

## Help Content

Here's a copy of the help contents that are display by running the script with the `-h` command-line argument.

```
(stuff here)
```

## References


<hr class="tight">
Return to [Bash Scriptiong](http://www.scheidel.net/#!pages/scripting_and_programming/bash.md)

<hr class="tight"><p class="timestamp">Page updated >= 2020.03.25 11:37 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
