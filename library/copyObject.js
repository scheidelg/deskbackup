/*============================================================================
function copyObject(sourceObject, targetObject, copyType)
------------------------------------------------------------------------------
Copy a JavaScript object by performing a deep copy of non-inherited
properties:

 - If a a source object's property is an object, then create a new object
   property in the target instead of simply copying the source object
   property.

   This means that target object properties will distinct object references,
   not simply references to the corresponding source object properties.

 - Recurse through the source to copy child children, grandchildren, etc.
   properties to the target.

 - If a circular reference (a child object refers to an ancestor object), then
   don't copy the circular reference or it's children properties.  Continue
   copying the rest of the object; and set a return value indicating a
   circular reference was found.

The copyType argument determines how any existing targetObject properties
will be handled: 0 or undefined = Deleted; 1 = replaced if they conflict with
a sourceObject property; 2 = retained even if they conflict with a
sourceObject property.

For example, given two objects:

    sourceObject = {"a": 1, "b": {"b_i": 2, "b_ii": 3}, "c": null}
    targetObject = {"a": 2, "b": {"b_ii": 5, "b_iii": 6}, "c": {}}

copyType === 0

    All existing targetObject properties are deleted before sourceObject
    is copied.  After the copy:

        targetObject = {"a": 1, "b": {"b_i": 2, "b_ii": 3}, "c": null}

    Existing properties are individually deleted instead of simply
    deleting the entire object so that any existing references to the
    object are still valid.

copyType === 1

    Existing targetObject properties are replaced if they conflict with a
    sourceObject property; otherwise existing targetObject properties are
    retained.  After the copy:

        targetObject = {"a": 1, "b": {"b_i": 2, "b_ii": 3, "b_iii": 6},
            "c": 4}

     - targetObject["a"] value of 2 is replaced with 1

     - targetObject["b"] is retained because both sourceObject["b"] and
       targetObject["b"] are objects with children properties

     - targetObject["b"]["b_ii"] value of 6 is replaced with 3

     - targetObject["b"]["b_iii"] property and value are retained because
       there is no sourceObject["b"]["b_iii"] to conflict with

     - targetObject["c"] value of {} is replaced with null; while both
       sourceObject["c"] and targetObject["c"] are objects, one is a null
       value while the other is an empty object

copyType === 2

    Existing targetObject properties are retained even if they conflict with a
    sourceObject property.  After the copy:

    sourceObject = {"a": 1, "b": {"b_i": 2, "b_ii": 3}, "c": null}
    targetObject = {"a": 2, "b": {"b_ii": 5, "b_iii": 6}, "c": {}}

        targetObject =  {"a": 2, "b": {"b_i": 2, "b_ii": 5, "b_iii": 6}, "c": {}}

     - targetObject["a"] value of 2 is retained, taking precedence over the
       sourceObject["a"] value of 1

     - targetObject["b"] is retained, including its child properties

     - targetObject["b"]["b_ii"] value of 5 is retained, taking precedence
       over sourceObject["b"]["b_ii"] value of 3

     - targetObject["b"]["b_iii"] property and value are retained
       because there is no sourceObject["b"]["b_iii"] to conflict with

     - targetObject["c"] value of {} (empty object) is retained, taking
       precedence over the sourceObject["c"] value of null

Note:

 - Only non-inherited properties are copied.

 - A valid source object and target object must be passed in as function
   arguments.

 - The properties of the copied targetObject will *not* enumerate in the same
   order as the properties of sourceObject, for two reasons.  First, we review
   the properties of the sourceObject in reverse order using while(keyIndex--)
   for slightly better performance, which means we copy the properties to
   targetObject in reverse order.  Second, if we retain existing properties
   with copyType 1 or 2, then the 'position' of those properties - relative
   to other properties - can be different in sourceObject and the copied
   targetObject.

 - If it weren't for copyType options 1 and 2, then this function could be
   much simpler.

 - If it weren't for copyType options 1 and 2 and using the return value to
   flag that circular references were found sourceObject, then we could simply
   return a new object instead of requiring a targetObject argument.

------------------------------------------------------------------------------
Arguments

sourceObject                        object

    The object to copy.

targetObject                        object

    The object to copy sourceObject into.

copyType                           number; optional

    A number that determines how any existing targetObject properties will be
    handled.

        0: All existing targetObject properties are  deleted before
           sourceObject is copied.

        1: Existing targetObject properties are replaced if they conflict with
           a sourceObject property; otherwise existing targetObject properties
           are retained.

        2: Existing targetObject properties are retained even if they conflict
           with a sourceObject property.

    See the function description for more detail.

------------------------------------------------------------------------------
Variables

authMessageElement                  object

    Reference to the web page element with id of 'ghpaAuthMessage'.

childpropertyKey                    string

    Used to iterate through sourceObject[propertyKey] properties.

keyStack                            string

    An array used as a stack to track the sourceObject keys that are being
    traversed through recursion.

    As the sourceObject keys are traversed, just before recursion the current
    propertyKey is pushed onto the stack; just after recursion that
    propertyKey is popped off the stack.
    
    The only purpose this serves is for error or log messages.  When
    reporting, we can use keyStack.join('.') to generate a string identifying
    the keys that were traversed to get to the current object.

    Keys are pushed onto keyStack at the same time object references are
    pushed onto objStack.  This means that keyStack[x] corresponds to
    objStack[x], and that the path represented by keyStack[0..x] can be used
    to access objStack[x].

objStack                            string

    As the sourceObject keys are traversed, just before recursion the current
    sourceObject[propertyKey] object is pushed onto the stack; just after
    recursion that object is popped off the stack.

    The purpose of this variable is so that we can check for circular
    references during recursion, and not recurse into an object if it is a
    circular reference.  If we're about to recurse into a property (that is an
    object), then we can check to see whether that object is already in
    objStack.  If it is, then the objects refers to one of its own ancestors;
    in other words, a circular reference.

    Keys are pushed onto keyStack at the same time object references are
    pushed onto objStack.  This means that keyStack[x] corresponds to
    objStack[x], and that the path represented by keyStack[0..x] can be used
    to access objStack[x].

    Note that if we didn't care about detailed reporting on the the circular
    reference - specifically, the path to the circular reference and the path
    to the referenced ancestor - then we wouldn't need the keyStack variable
    and objStack could be a WeakSet or WeakMap variable instead of an array;
    which could be slightly faster.

propertyKey                         string

    Used to iterate through sourceObject properties.

------------------------------------------------------------------------------
Return Value

    0: success, no issues
    1: invalid function arguments
    2: circular reference detected and logged in console; may or may not be
       a fatal error, depending on the specific use of the function
------------------------------------------------------------------------------
2020.04.24-01, original version

------------------------------------------------------------------------------
(c) Greg Scheidel, 2020.04.24, v1.0

Licensed under the GNU General Public License v3.0.
----------------------------------------------------------------------------*/
function copyObject(sourceObject, targetObject, copyType) {

    /* Initialize objStack (for circular reference checks) to the initial
     * object, with corresponding placeholder text in keyStack. */
    const keyStack = ['(root)'];
    const objStack = [sourceObject];

    /* Define a child function that will be called for the recursive copy.
     *
     * Note:
     *
     *  - Parent and child arguments are named the same; child arguments
     *    take precedence within the scope of the child function.
     *
     *  - copyType, keyStack, and objStack aren't passed to the child
     *    copyObjectRecursion() function.  There's no need, since they will
     *    be available within the scope of the parent function; copyType
     *    doesn't change value across recursive calls; and keyStack and
     *    objStack elements change across recursive calls but values are
     *    pushed/popped before/after each recursive call and the recursive
     *    calls aren't being executed in parallel (if they were, then each
     *    recursive call would need its own copy of the stacks).
     *
     *  - Return true if no circular references are found; return false if
     *    circular references are found. */
    function copyObjectRecursion(sourceObject, targetObject) {
        /* Variable to hold return value.  Set to true at start; set to false
         * if there is an error; whenever recursing, set to 'recursion &&
         * current value'. */
        let returnValue = true;

        /* Iterate through all non-inherited properties of sourceObject.
         *
         * We're using Object.getOwnPropertyNames() to create an array of
         * enumerable and non-enumerable non-inherited properties, and
         * while(keyCounter--) to iterate - as opposed to a for...in loop; for
         * better performance.  The trade-off is using up a very small bit
         * more memory for the array. */
        const sourceObjectKeys = Object.getOwnPropertyNames(sourceObject);
        let keyIndex = sourceObjectKeys.length;
        while(keyIndex--) {
            const propertyKey = sourceObjectKeys[keyIndex];

            /* If copyType 1, then delete all existing targetObject
             * properties that conflict with sourceObject properties.
             *
             * Properties that exist in both the sourceObject and targetObject
             * but do *not* conflict:
             *
             *  - Properties with the same type and value.
             *
             *    There's no need to delete and recreate a property with the
             *    same value.
             *
             *  - Properties that are both non-null objects.
             *
             *    There's no need to delete and recreate a property that is
             *    already a non-null object and will be used as a non-null
             *    object.  Also, deleting the existing non-null object would
             *    delete any child properties - which we want to keep, at
             *    least to keep, if they don't conflict with child properties
             *    in sourceObject.
             *
             * Examples:
             *
             *    sourceObject[]===null and targetObject[]===null are both
             *    objects and have the same value.
             *
             *    sourceObject[]===0 and targetObject[]===0 are both numbers
             *    and have the same value.
             *  
             *    sourceObject[]==="" and targetObject[]==="" are both strings
             *    and have the same value.
             *  
             *    sourceObject[]==={} and targetObject[]==={} are both objects
             *    but do *not* have the same value.
             *
             * Note that for copyType 0, all existing targetObject properties
             * were cleared before starting the recursion.  For copyType 2,
             * we want existing targetObject properties to take precedence
             * (i.e., be retained). */
            if (copyType === 1 &&
                targetObject.hasOwnProperty(propertyKey) &&
                sourceObject[propertyKey] !== targetObject[propertyKey] &&
                !(typeof sourceObject[propertyKey] == 'object' &&
                    sourceObject[propertyKey] !== null &&
                    typeof targetObject[propertyKey] == 'object' &&
                    targetObject[propertyKey] !== null)) {

                /* Delete the existing targetObject property. */
                delete targetObject[propertyKey]
            }

            /* If sourceObject[propertyKey] is a non-null object, then we'll
             * want to recurse into it. */
            if (typeof sourceObject[propertyKey] == 'object' && sourceObject[propertyKey] !== null) {

                /* If the property doesn't already exist in the target, then
                 * create it as an empty object so that we can recurse into
                 * both sourceObject and targetObject. */
                if (! targetObject.hasOwnProperty(propertyKey)) {
                    targetObject[propertyKey] = {};
                }

                /* If the property exists in the target - either because it
                 * already did or because we just created it - and is a
                 * non-null object, then recurse into  sourceObject and
                 * targetObject to copy any sourceObject properties.
                 *
                 * Combined with previous actions based on copyType 0 and 1,
                 * and with the earler conditional creation of an empty
                 * object, this test allows us to replace existing target
                 * properties for copyType 0, retain existing non-conflicting
                 * non-conflicting target properties for copyType 1, and
                 * retain all existing target properties for copyType 2.
                 *
                 * We could add an additional check here for whether
                 * sourceObject[propertyKey] has any child properties, and
                 * only recurse if it does.  However, that would be more
                 * computationally expensive then just recursing and returning
                 * when the 'for' loop generates an empty set. */
                if (targetObject.hasOwnProperty(propertyKey) &&
                    typeof targetObject[propertyKey] == 'object' &&
                    targetObject[propertyKey] !== null) {

                    /* Look for the sourceObject[propertyKey] value (i.e., the
                     * object reference) in the stack of ancestor object
                     * references.  If we find it, then
                     * sourceObject[propertyKey] is a circular reference.
                     */
                    let ancestorCheck = objStack.indexOf(sourceObject[propertyKey]);

                    /* Recurse if this isn't a circular reference. */
                    if (ancestorCheck == -1) {
                        /* Push this propertyKey and the corresponding object
                         * reference onto the keyStack and objStack so that we
                         * can test whether descendant properties are circular
                         * references. */
                        keyStack.push(propertyKey);
                        objStack.push(sourceObject[propertyKey]);

                        /* Recurse; if recursion returns false then flip
                         * returnValue to false. */
                        returnValue = copyObjectRecursion(sourceObject[propertyKey], targetObject[propertyKey]) && returnValue;

                        /* Pop the processed propertyKey and corresponding
                         * object reference off keyStack and objStack. */
                        keyStack.pop();
                        objStack.pop();

                    /* If a circular reference was detected, then generate a
                     * log message and set returnValue to false.  However, do
                     * *not* error out and stop processing. We want to copy
                     * all of the branches of the original object, as far as
                     * each branch can go before hitting a circular
                     * reference. */
                    } else {
                        /* Note that this is console.log() instead of
                         * console.error().  A circular reference may or may
                         * not be an error depending on the specific use case
                         * for cloning an object. */
                        console.log(`WARNING: copyObject() circular reference detected in sourceObject; ${keyStack.join('.')}.${propertyKey} = ${keyStack.slice(0, ancestorCheck+1).join('.')}`);
                        returnValue = false;
                    }
                }

            /* If sourceObject[propertyKey] isn't an object or is a null
             * object, then we don't want to recurse; just set
             * targetObject[propertyKey]. */
            } else {
                /* If the target property doesn't exist - either because it
                 * wasn't present to begin with or because we deleted it -
                 * then set it.
                 *
                 * Combined with previous actions based on copyType 0 and 1,
                 * this test allows us to replace existing target properties
                 * for copyType 0, retain existing non-conflicting target
                 * properties for copyType 1, and retain all existing target
                 * properties for copyType 2. */
                if (! targetObject.hasOwnProperty(propertyKey)) {
                    targetObject[propertyKey] = sourceObject[propertyKey];
                }
            }
        }

        return(returnValue);
    }

    /* Note: Technically the argument validation and (if copyType is 0 or
     * undefined) initial deletion of all object properties could be performed
     * in the recursive child function... In which case we wouldn't need a
     * parent function at all and could just call the recursive function to
     * begin with. However, that would mean unnecessarily including and
     * running this code in every recursive execution.  This is a better
     * trade-off. */

    /* validate argument types and values */
    if (typeof sourceObject != 'object') {
        console.error("copyObject() 'sourceObject' argument isn't an object.");
        return(1);
    }

    if (typeof targetObject != 'object') {
        console.error("copyObject() 'targetObject' argument isn't an object.");
        return(1);
    }

    if (!(typeof copyType == 'number') && (copyType < 0 || copyType > 2)) {
        console.error("copyObject() 'copyType' argument must be a number between 0 and 2 (inclusive).");
        return(1);
    }

    /* If copyType is 0 or undefined (i.e., wasn't passed as an argument or
     * was explicitely passed as undefined), then delete any existing
     * targetObject properties.
     *
     * Existing properties are individually deleted instead of simply
     * deleting the entire object so that any existing references to the
     * object are still valid. */
    if (! copyType) {
        for (const propertyKey in targetObject){
            if (targetObject.hasOwnProperty(propertyKey)){
                delete targetObject[propertyKey];
            }
        }
    }

    /* Kick off the recursive child function.
     *
     * The child function will return false if it ran into a circular
     * reference; the parent function should return 2.  The child function
     * will return true if it didn't run into a circular reference; the parent
     * function should return 0.
     *
     * Note: Inside the child function, before recursion we push the next
     * object onto objStack, and it's key onto keystack; after recursion we
     * pop those values.  We don't need to push here because we already set
     * the initial values at the top of this function when we created the
     * objStack and keyStack variables; we don't need to pop here because our
     * next step is to exit this function, and we don't need the variables any
     * more (the variables will go out of scope and the referenced memory will
     * be reclaimed). */
    return(copyObjectRecursion(sourceObject, targetObject, copyType) ? 0 : 2);
 }
