# copyObject()

While writing functions to validate and manipulate application configurations, where those configurations are represented in memory as Javascript objects, I needed to perform a deep copy of Javascript objects.

See this [blog entry](/pages/blog.md#04/24_-_Shallow_Copy_vs._Deep_Copy,_and_copyObject) for a brief overview of shallow copy vs. deep copy.

Since I needed to combine different configuration 'branches' I included the ability to retain existing properties of the target object. There are three options:

 - Delete any existing target object properties.

 - Replace existing target object properties if they conflict with source object properties; retain existing target object properties that do not conflict with source object properties.

 - Retain existing target object properties even if they conflict with a source object property.

Besides the deep copy functionality itself, this code illustrates:

 - iterating through Javascript object properties,

 - manipulating Javascript objects,

 - recursion, and

 - checking for circular recursion.

Click [here](https://www.scheidel.net/library/copyObject.js) to view the entire Javascript function, along with some code to demonstrate it's use.

## References

 1. [Cyber Defense NetWars](https://www.sans.org/netwars/cyber-defense) on sans.org
 
    [https://www.sans.org/netwars/cyber-defense]()
 
 2. [Ryan Nicholson](https://www.sans.org/instructors/ryan-nicholson) profile on sans.org
 
    [https://www.sans.org/instructors/ryan-nicholson]()

 3. [cloneObject() Code](https://www.scheidel.net/library/cloneObject.js)

    Source code for the entire Javascript function, along with some code to demonstrate it's use.

    [https://www.scheidel.net/library/cloneObject.js]()

 4. [cloneObject() Minified Code](https://www.scheidel.net/library/cloneObject-mini.js)

    Source code for the entire Javascript function, minified to ~1,100 characters.

    [https://www.scheidel.net/library/cloneObject-mini.js]()

<hr class="tight">
Return to [Javascript](http://www.scheidel.net/#!pages/scripting_and_programming/javascript.md)

<hr class="tight"><p class="timestamp">Page updated >= 2020.04.24 11:32 ET</p>
