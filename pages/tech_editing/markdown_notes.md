# Markdown Notes

This is a collection of markdown notes, tips, and references (primarily for me to use on this web site with MDwiki).

## Quick Reference

A quick reference for things I've used (or started to use) frequently.

| Description                                 | Markdown     | Example    |
| ------------------------------------------- | ------------ | ---------- |
| Italics emphasis                            | `*text*`     | *text*     |
| Bold emphasis                               | `**text**`   | **text**   |
| Italics and bold emphasis                   | `**_text_**` | **_text_** |
| Code inline with text; use single backticks | `` `text` `` | `text`     |

## Code Blocks

Display a block of text as code by either (a) indenting each line of raw text with four spaces:

```
    code line 1
    code line 2
```

Or (b) opening and closing the code block with three backticks:

    ```
    code line 1
    code line 2
    ```

With the 'three backticks' method you can get syntax highlighting.  For example:

    ```html
    Click <a href="http://www.example.com" target="_blank">here</a> to activate the web page.
    ```

Renders as:

```html
Click <a href="http://www.example.com" target="_blank">here</a> to activate the web page.
```

See [http://dynalon.github.io/mdwiki/#!quickstart.md#Syntax_highlighting]() for additional detail.

## Right, Center, or Full Justification 

Markdown doesn't appear to have a built-in feature to right, center, or fully justify content.  That's OK, just use the appropriate HTML tag with the 'align' attribute or the CSS style syntax.

```html
<p align="right">text</p>
<p align="center">text</p>
<p align="justify">text</p>
<p style="text-align:right">text</p>
<p style="text-align:center">text</p>
<p style="text-align:justify">text</p>
```

## Activating Links in New Windows

Markdown creates an anchor tag (`<a>`) for any URLs found in source files.  This happens both when explicitly using markdown syntax to identify a URL, and when markdown identifies what it believes is a URL. The following markdown:

```markdown
[Click here](https://www.example.com) to activate the web page.
An example web page can be found at https://www.example.com.
```

Results in the following HTML:

```html
<a href="https://www.example.com">Click here</a> to activate the web page.
<br>
An example web page can be found at <a href="https://www.example.com">https://www.example.com</a>.
```

These automatically created anchor tags don't include a `target="_blank"` attribute/value pair, which means that the referenced content is rendered in the current web browser window or tab when the user clicks on the link.

If we want the URL content to automatically render in a new window or tab, then we have to create our own anchor tag with a `target="_blank"` attribute/value pair. For example, if we wanted to hyperlink the word 'here' to `www.example.com`:

```html
Click <a href="https://www.example.com" target="_blank">here</a> to activate the web page.
```

However, if we want to use the actual URL as the displayed text then we need to prevent markdown from interpreting that displayed text as a URL.  An easy way to do this is to add the HTML code `<span></span>` after the URI specifier and after every period in the FQDN.  For example:

```HTML
Click <a href="https://www.example.com" target="_blank">http://<span></span>www.<span></span>example.<span></span>com</a> to activate the web page.
```

## Other References

Other markdown references:

 * *<a href="https://daringfireball.net/projects/markdown/">Daring Fireball / Markdown</a>* by John Gruber
 
   The original markdown specification.
   
    [https://daringfireball.net/projects/markdown/]()
   
 * *<a href="https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet">Markdown Cheatsheet</a>* by Adam Pritchard

   A "quick reference and showcase" for common markdown, providing the markdown to use and examples of what it will look like.
   
   [https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet]()

 * *<a href="http://dynalon.github.io/mdwiki">MDwiki Wiki</a>* by Timo Dörr
 
   The MDwiki Wiki documenting how to set up and use MDwiki.  The **Docs** section has multiple pages with useful tips and examples
   
   [http://dynalon.github.io/mdwiki/#!quickstart.md]()
   
   [http://dynalon.github.io/mdwiki/#!layout.md]()

<hr class="tight"><p class="timestamp">Page updated >= 2020.03.25 08:29 ET -- Site updated: <span id="timestamp"></span></p>
<script type='text/javascript'>document.getElementById("timestamp").innerHTML = Date(document.lastModified);</script>
