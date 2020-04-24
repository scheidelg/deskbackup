# Javascript

## cloneObject

This is a Javascript function that 'clones' a JavaScript object by performing a deep copy of non-inherited properties:

 - For a child property that is an object, create a new object in the target instead of simply copying the source object.

   This means that target object properties will be separate from source object properties, not simply references to the corresponding source object properties.

 - Recurse through the source to copy child children, grandchildren, etc. properties to the target.

 - If a circular reference (a child object refers to an ancestor object), then the circular reference and any child properties aren't copied but the rest of the object is still copied; and the function return value will be indicate a circular reference was found.

Instead of creating a new target object, the source object is copied to an existing target object. This allows existing target object properties to be retained, effectively merging the source object into the target object. An argument to the function controls how existing targetObject properties are handled:

 - Deleted

 - Replaced if they conflict with a sourceObject property
 
 - Retained even if they conflict with a sourceObject property

Click [here](cloneObject.md) for details.

## next item

this is the next item

<hr class="tight"><p class="timestamp">Page updated >= 2020.04.24 09:31 ET</p>
