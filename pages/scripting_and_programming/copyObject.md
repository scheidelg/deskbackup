# copyObject()

This function performs a deep copy of Javascript objects.

See this [blog entry](/pages/blog.md#04/24_-_Shallow_Copy_vs._Deep_Copy,_and_copyObject) for a brief overview of shallow copy vs. deep copy.

Click [here](https://www.scheidel.net/library/copyObject.js) to view the Javascript function along with some code to demonstrate it's use. Please note that the full Javascript code includes detailed comments to explain the function's use, arguments, variables, and logic.

Click [here](https://www.scheidel.net/library/copyObject-mini.js) to view the Javascript function minified to ~1,100 characters.

## Retaining Existing Properties

The function has the the ability to retain existing properties of the target object. There are three options:

 - Delete any existing target object properties.

 - Replace existing target object properties if they conflict with source object properties; retain existing target object properties that do not conflict with source object properties.

 - Retain existing target object properties even if they conflict with a source object property.

## Concepts and Techniques Illustrated

Besides the deep copy functionality itself, this code illustrates:

 - iterating through Javascript object properties,

 - manipulating Javascript objects,

 - recursion, and

 - checking for circular recursion.

## References

 1. [copyObject() Code](/library/copyObject.js)

    Source code for the entire Javascript function, along with some code to demonstrate it's use. Includes detailed comments to explain the function's use, arguments, variables, and logic.

 2. [copyObject() Minified Code](/library/copyObject-mini.js)

    Source code for the Javascript function minified to ~1,100 characters.

 3. [Blog Entry - 04/24 - Shallow Copy vs. Deep Copy, and copyObject](/pages/blog.md#04/24_-_Shallow_Copy_vs._Deep_Copy,_and_copyObject)

    A brief overview of shallow copy vs. deep copy.

<hr class="tight">
Return to [Javascript](/pages/scripting_and_programming/javascript.md) page.

<hr class="tight"><p class="timestamp">Page updated >= 2020.04.24 11:32 ET</p>
