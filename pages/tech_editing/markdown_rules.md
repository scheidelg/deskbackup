# Markdown Rules

This is a collection of rules for me to follow when using markdown (primarily on this web site with MDwiki).

OK, maybe they're more like guidelines. There are always edge cases where it doesn't make sense to apply the rules. ;)

## Open External Content in New Windows or Tabs

It bugs me when I'm a web page with "step-by-step" instructions includes a link to external content, and clicking on the link renders that external content in the same tab -- meaning that the instructions are now replaced with the new content.

In those cases, make sure to format the link so the content opens in a a new tab and/or window.  See [Activating Links in New Windows]( /pages/tech_editing/markdown_notes.md#Activating_Links_in_New_Windows).

## Titles of Web Pages and Books

Use italics (i.e., soft-emphasis) for titles of web pages and books.

## Horizontal Rule Breaks

I generally prefer a stronger indicator of a new section than just a slightly larger font and a small amount of leading white space (i.e., top margin).  I'm trying out a few different formatting options; for now consider whether it makes more sense to use `<hr class="tight">` or update relevant CSS styles to have an underline.

## Page Timestamps

Include a timestamp at the bottom of every `*.md` file  that gets rendered on its own page (i.e., every file except `navigation.md`).

Currently I'm using the following for timestamps:

```HTML
<hr class="tight"><p class="timestamp">Page updated >= 2020.03.23 14:48 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
```

See the [blog entry on timestamps](/pages/blog.md#03/23_-_MDwiki_and_File_Timestamps).

## Displaying URLs for External Links

Particuarly for any content that might be printed - as opposed to only being read in a web browser - make sure to provide the URL as text.

## Citing References

Related to dispalying URLs for external links... When referencing external content include a superscript citation in the format of:

&nbsp;&nbsp;&nbsp;&nbsp;This is some cited text.<sup>\[1\]</sup>

To achieve this when the citation itself is intended to be plain text:

    <sup>\[1\]<sup>
    
To achieve this when the citation itself is intended to be a link to a URL:

    <sup>[&#91;1&#93;](https://www.example.com)</sup>

<hr class="tight"><p class="timestamp">Page updated >= 2020.03.24 18:42 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
