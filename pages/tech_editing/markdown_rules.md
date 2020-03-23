# Markdown Rules

This is a collection of rules for me to follow when using markdown (primarily on this web site with MDwiki).

OK, maybe they're more like guidelines. There are always edge cases where it doesn't make sense to apply the rules. ;)

<hr class="tight">
## Open External Content in New Windows or Tabs

It bugs me when I'm a web page with "step-by-step" instructions includes a link to external content, and clicking on the link renders that external content in the same tab -- meaning that the instructions are now replaced with the new content.

In those cases, make sure to format the link so the content opens in a a new tab and/or window.  See [Activating Links in New Windows]( /pages/tech_editing/markdown_notes.md#Activating_Links_in_New_Windows).

## Displaying URLs for External Links

Particuarly for any content that might be printed - as opposed to only being read in a web browser - make sure to provide the URL as text.

## Horizontal Rule Breaks

I generally prefer to see a stronger indicator of a new section than just a slightly larger font and a small amount of leading white space (i.e., top margin).  I'm trying out a few different formatting options; for now:

 * If there is introductory text immediately after the page header (H1 style), then insert `<hr class="tight">` between that introductory text and the first H2 header.
 
 * If there isn't any introductory text immediately after the page header, then **don't** insert a horizontal rule before the first H2 header.
 
 * Consider whether readability is improved by inserting a horizontal rule vs. a larger top margin for the H2 style.

## Page Timestamps

Include a timestamp at the bottom of every `*.md` file  that gets rendered on its own page (i.e., every file except `navigation.md`).

Currently I'm using the following for timestamps:

```HTML
<hr class="tight"><p class="timestamp">Page updated: 2020.03.23 14:48 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
```

See the [blog entry on timestamps](/pages/blog.md#MDwiki_and_File_Timestamps).

## Titles of Web Pages and Books

Use italics (i.e., soft-emphasis) for titles of web pages and books.

<hr class="tight"><p class="timestamp">Page updated: 2020.03.23 18:16 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
