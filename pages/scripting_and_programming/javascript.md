# Javascript

## copyObject()

A Javascript function that copies a JavaScript object by performing a deep copy of non-inherited properties.

See this [blog entry](/pages/blog.md#04/24_-_Shallow_Copy_vs._Deep_Copy,_and_copyObject) for a brief overview of shallow copy vs. deep copy.

I needed this functionality as part of functions I was writing to validate and manipulate application configurations, where those configurations are represented in memory as Javascript objects. Since I needed to combine different configuration 'branches' I included the ability to retain existing properties of the target object. There are three options:

 - Delete any existing target object properties.

 - Replace existing target object properties if they conflict with source object properties; retain existing target object properties that do not conflict with source object properties.

 - Retain existing target object properties even if they conflict with a source object property.

Besides the deep copy functionality itself, this code illustrates:

 - iterating through Javascript object properties,

 - manipulating Javascript objects,

 - recursion, and

 - checking for circular recursion.

Click [here](copyObject.md) for more details.

Click [here](https://www.scheidel.net/library/copyObject.js) to view the entire Javascript function, along with some code to demonstrate it's use.

Click [here](https://www.scheidel.net/library/copyObject-mini.js) to view the entire Javascript function, minified to ~1,100 characters.

## next item

this is the next item

<hr class="tight"><p class="timestamp">Page updated >= 2020.04.24 11:07 ET</p>
