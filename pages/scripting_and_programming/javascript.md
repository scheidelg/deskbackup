# JavaScript

## copyObject()

A JavaScript function that copies a JavaScript object by performing a deep copy of non-inherited properties, optionally retaining existing properties of the target object so that the source and target are effectively merged.

See [this blog entry](/pages/blog.md#04/24_-_Shallow_Copy_vs._Deep_Copy,_and_copyObject) for a brief overview of shallow copy vs. deep copy.

Besides the deep copy functionality itself, this code illustrates:

 - iterating through JavaScript object properties,

 - manipulating JavaScript objects,

 - recursion, and

 - checking for circular recursion.

Click [here](copyObject.md) for more details.

Click [here](https://www.scheidel.net/library/copyObject.js) to view the JavaScript function along with some code to demonstrate it's use. Please note that the full JavaScript code includes detailed comments to explain the function's use, arguments, variables, and logic.

Click [here](https://www.scheidel.net/library/copyObject-mini.js) to view the JavaScript code minified to ~1,100 characters.

## Configuration Settings Management (CSM)

A simple framework for creating and working with application configuration settings as JavaScript objects. There are three main components:

 - A configuration schema that determines the structure of the application's configuration settings including valid options, required options, values for each option, and default values. The intent is that the configuration schema be defined by the application developer and not be modified by an application administrator or user.

 - A configuration that defines the configuration for the application. The intent is that the configuration file be defined or by the application administrator or possibly by the user through an application interface.

 - Functions to work with the configuration schema and configuration including reading the configuration schema and configuration from a JSON file, validating the configuration schema's structure and contents, and validating that the configuration is compatible with the configuration schema.

The configuration schema and configuration can be defined in either a JSON file or JavaScript object.  The configuration schema supports:

 - nested options,

 - options classes with properties that can be inherited by options,

 - use of regular expressions to identify allowable option names and values, and

 - regular expression classes that can be used for option names and values.

Click [here](csm.md) for more details.

Click [here](https://www.scheidel.net/library/csm.js) to view the JavaScript functions along with some code to demonstrate it's use. Please note that the full JavaScript code includes detailed comments to explain the function's use, arguments, variables, and logic.

Click [here](https://www.scheidel.net/library/csm-mini.js) to view the JavaScript code minified to ~XXXXXXXXXXXXXXXXXXx characters.

<hr class="tight"><p class="timestamp">Page updated >= 2020.04.25 14:13 ET</p>
