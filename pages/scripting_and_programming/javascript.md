# Javascript

## cloneObject

This is a Javascript function that 'clones' a JavaScript object by performing a deep copy of non-inherited properties:

 - If a source object's property is an object, then create a new object property in the target instead of simply copying the source object property.

   This means that target object properties will be distinct object references, not simply references to the corresponding source object properties.

 - Recurse through the source to copy child children, grandchildren, etc. properties to the target.

 - If a circular reference (a child property refers to an ancestor object), then don't copy the circular reference or its children properties. Continue copying the rest of the object; and set a return value indicating a circular reference was found.

Instead of creating a new target object, the source object is copied to an existing target object. This allows existing target object properties to be retained, effectively merging the source object into the target object. An argument to the function controls how existing target object properties are handled:

 - Deleted

 - Replaced if they conflict with a sourceObject property
 
 - Retained even if they conflict with a sourceObject property

Click [here](cloneObject.md) for details.

## next item

this is the next item

<hr class="tight"><p class="timestamp">Page updated >= 2020.04.24 09:31 ET</p>
