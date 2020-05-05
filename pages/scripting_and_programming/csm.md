# Configuration Settings Management (CSM)

Configuration Settings Management (CSM) is a simple framework for creating and working with application configuration settings as JavaScript objects. There are three main components:

 - A configuration schema that determines the structure of the application's configuration settings including valid options, required options, values for each option, and default values. The configuration schema should be defined by the application developer and not be modified by an application administrator or user.

 - A configuration that defines the configuration for the application. The configuration file should be defined by the application developer or administrator, or possibly by the administrator or user through an application interface.

 - Functions to work with the configuration schema and configuration including reading the configuration schema and configuration from a JSON file, validating the configuration schema's structure and contents, and validating that the configuration is compatible with the configuration schema.

Click [here](/library/csm.js) to view the JavaScript functions along with some code to demonstrate their use. Please note that the full JavaScript code includes detailed comments to explain the function use, arguments, variables, and logic.

Click [here](/library/csm-mini.js) to view the JavaScript code minified to ~XXXXXXXXXXXXXXXXXXx characters.

## Configuration Schema

A configuration schema can be defined in either a JavaScript object included in the source code or in a JSON file that is read.  A configuration schema includes the following:

 - [Option definitions](#Option_Definitions) that determine what options can be used in the [configuration file](#Configuration_File), including default values.

 - [Schema directives](#Schema_Directives) that define either:
 
    - details of options such as whether the option is required, whether the option should be created by default, and acceptable values;

    - [regular expression classes](#Regular_Expression_Classes) that can be used with option values and dynamic option names; or

    - [option classes](#Option_Classes) that can be inherited by options as part of their [option definitions](#Option_Definitions) or corresponding [schema directives](#Schema_Directives)..
 
and can include:

 - option defin

 - option classes with properties that can be inherited by options,

 - regular expressions to identify allowable option names and values, and

 - regular expression classes that can be used for option names and values.

### Option Definitions

An option definition can either define nesting or the the default value for each option.  (blah, blah blah)

(variable name name definitions)

### Schema Directives

(describe schema directives for defining options; reference 'regular expression classes' and 'option classes')

### Regular Expression Classes

(note this is a form of 'schema directive')

### Option Classes

(note this is a form of 'schema directive')

### Comments

(how to use comments in a configuration schema file; in a variable declaration just follow JavaScript rules; this subsection is essentially duplicated under Configuration File)

### Terminology

(might not need this; or might keep it as a summary, but bump up to second level instead of keeping it under Configuration Schema)

### Structure

A configuration schema has the following structure: (need to reword this intro in light of the previous sections/subsections structure)

```
{
    // '(regexClasses)' is optional; it can be used to define one or more
    // regular expression classes
    "(regexClasses)": {
        "<regexClassName>": "<regexClassExpression>"
        [...]
    },
    
    // '(optionClasses)' is optional; it can be used to define one or more
    // option classes; each option class is defined by an option definition
    // and a matching directive
    "(optionClasses)": {
        // one or more option definitions
        "<optionClassName>": <optionClassValue>,
        [...]

        // matching directives
        "(<optionClassName>)" : {
            <directive-options>
        }
        [...]
    }

    // one or more option definitions
    "<optionName>": <optionNameValue>,
    [...]

    // matching directives
    "(<optionName>)": {
        <directive-options>
    }
    [...]
}
```

(lots more here)

## Configuration File

## Functions

## Concepts and Techniques Illustrated

This code illustrates:

 - reading file contents, including filtering out comments;

 - async functions and promises;

 - iterating through Javascript object properties;

 - manipulating Javascript objects;

 - recursion; and

 - checking for circular recursion.

## References

 1. [Configuration Settings Management (CSM) Code](/library/csm.js)

    Source code for the Javascript functions, along with some code to demonstrate their use. Includes detailed comments to explain function use, arguments, variables, and logic.

    [https://www.scheidel.net/library/csm.js]()

 2. [Configuration Settings Management (CSM) Minified Code](/library/csm-mini.js)

    Source code for minified to ~XXXXXXXXXXXXXX characters.

    [https://www.scheidel.net/library/csm-mini.js]()

<hr class="tight">
Return to [JavaScript](/pages/scripting_and_programming/javascript.md) page.

<hr class="tight"><p class="timestamp">Page updated >= 2020.05.02 17:05 ET</p>
