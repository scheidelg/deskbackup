# Markdown Rules

This is a collection of rules for me to follow when using markdown (primarily on this web site with MDwiki).

OK, maybe they're more like guidelines. There are always edge cases where it doesn't make sense to apply the rules. ;)

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

## Relative vs. Absolute URLs

Conventional wisdom and 'best practice' is to use relative URLs whenever possible. For example, if the absolute path to this file is `/pages/tech_editing/markdown_rules.md` and we wanted to reference a file in `/pages/tech_editing/markdown_notes.md`, then we'd just reference `markdown_notes.md`. Both files are in the same directory so there's no need to include the full path.

Likewise, there's no need to preface the URL with the URI specifier and FQDN of `http://www.scheidel.net`.

I agree with not including the URI specifier and FQDN.  I'm not quite onboard with using the relative URL within the website; in many cases maintaining URLs when a directory or file location changes is more of a chore with relative URLs because it's harder to find all of the URLs that need to be updated and to figure out exactly how to update them. With full URLs I can easily search for and find URLs that need to be updated.

So:

 - For URLs that specify anchors within the same page, use the relative URL by just specifying the anchor. For example: `[Citing References](#Citing_References)`
 
 - For URLs that reference other pages on this site, use the full URL but without the URI specifier and FQDN. For example: `See the [blog entry on timestamps](/pages/blog.md#03/23_-_MDwiki_and_File_Timestamps).`

## Displaying URLs for External Links

Particuarly for any content that might be printed - as opposed to only being read in a web browser - make sure to provide the URL as text.

## Open External Content in New Windows or Tabs

It bugs me when I'm a web page with "step-by-step" instructions includes a link to external content, and clicking on the link renders that external content in the same tab -- meaning that the instructions are now replaced with the new content.

In those cases, make sure to format the link so the content opens in a a new tab and/or window.  See the Markdown Notes on [Activating Links in New Windows](/pages/tech_editing/markdown_notes.md#Activating_Links_in_New_Windows).

## Citing References

When referencing external content include a superscript citation in the format of:

&nbsp;&nbsp;&nbsp;&nbsp;This is some cited text.<sup>\[1\]</sup>

To achieve this when the citation itself is intended to be plain text:

    <sup>\[1\]<sup>
    
To achieve this when the citation itself is intended to be a link to a URL:

    <sup>[&#91;1&#93;](https://www.example.com)</sup>

<hr class="tight"><p class="timestamp">Page updated >= 2020.03.26 09:33 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
