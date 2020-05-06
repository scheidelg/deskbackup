# Configuration Settings Management (CSM)

Configuration Settings Management (CSM) is a simple framework for creating and working with application configuration settings as JavaScript objects. There are three main components:

 - A configuration schema that determines the structure of the application's configuration settings including valid options, required options, values for each option, and default values. The configuration schema should be defined by the application developer and not be modified by an application administrator or user.

 - A configuration that defines the configuration for the application. The configuration file should be defined by the application developer or administrator, or possibly by the administrator or user through an application interface.

 - Functions to work with the configuration schema and configuration including reading the configuration schema and configuration from a JSON file, validating the configuration schema's structure and contents, and validating that the configuration is compatible with the configuration schema.

Click [here](/library/csm.js) to view the JavaScript functions along with some code to demonstrate their use. Please note that the full JavaScript code includes detailed comments to explain the function use, arguments, variables, and logic.

Click [here](/library/csm-mini.js) to view the JavaScript code minified to ~XXXXXXXXXXXXXXXXXXx characters.

## Configuration Schema

A configuration schema can be defined in either a JavaScript object variable, or in a JSON file that is read into a JavaScript object variable.  A configuration schema includes the following:

 - [Option declarations](#Option_Declarations) that determine what configuration options can be used in the [configuration file](#Configuration_File), including default values.

 - [Schema directives](#Schema_Directives) that define either:
 
    - details of configuration options such as whether the option is required, whether the option should be created by default, and acceptable values;

    - [regular expression classes](#Regular_Expression_Classes) that can be used with option values and dynamic option names; or

    - [option classes](#Option_Classes) that can be inherited by options as part of their [option declarations](#Option_Declarations) or corresponding schema directives.
 
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
    // option classes; each option class is defined by an option declaration
    // and a matching schema directive
    "(optionClasses)": {
        // one or more option declarations
        "<optionClassName>": <optionClassValue>,
        [...]

        // matching schema directives
        "(<optionClassName>)" : {
            <directive-options>
        }
        [...]
    }

    // one or more option declarations
    "<optionName>": <optionNameValue>,
    [...]

    // matching  schema directives
    "(<optionName>)": {
        <directive-options>
    }
    [...]
}
```

### Example Configuration Schema

```
(use the GHPA configuration schema)
```

### Option Declarations

Option declarations determine what configuration options can be used in the [configuration](#Configuration). An option declaration can take one of two forms.

 1. A key-value pair where the key is the name of the option and the value is the option's default value.

    In the [example configuration schema](#Example_Configuration_Schema), the `"tokensOnly": true` key-value pair is an option declaration.  The name of the option is `tokensOnly`; the default value of the option is `true`.

 2. An object definining an option block that contains (i.e., nests) additional configuration options and corresponding [schema directives](#Schema_Directives).

    There is no 'default value' in this case. Default values would be defined for the individual options nested inside the option block.

    In the [example configuration schema](#Example_Configuration_Schema), the text `"pageOptions": { ... }` is an option declaration that defines an option block.

Option declarations can define either static or variable option names.

 - A static option name in a configuration must exactly match the key specified in the configuration schema's option declaration.

   In the [example configuration schema](#Example_Configuration_Schema), the text `"tokensonly": true` is an option declaration for a static option name.

 - A variable option name in a configuration must match the regular expression defined by the `optionRegex` [directive option](#Directive_Options) in the option's [schema directive](#Schema_Directives). 

   A variable option name is identified by starting the name with an asterisk character ('\*') and using the `optionRegex` directive option.

   In the [example configuration schema](#Example_Configuration_Schema), the text `"*ghpaClass": {}` is an option declaration with a variable option name.

   Multiple option names can be used in a configuration based on a single option declaration for a variable option name, as long as each option name in the configuration is unique at that level of the configuration. For example, the `"*ghpaClass": {}` option declaration supports a configuration of `"global": { ... }, "extra-repo": { ... }, "second-org": { ...}`.

### Schema Directives

(describe schema directives for defining options; reference 'regular expression classes' and 'option classes')

### Regular Expression Classes

(note this is a form of 'schema directive')

### Option Classes

(note this is a form of 'schema directive')

### Comments

(how to use comments in a configuration schema file; in a variable declaration just follow JavaScript rules; this subsection is essentially duplicated under Configuration File)

## Terminology

(might not need this; or might keep it as a summary, but bump up to second level instead of keeping it under Configuration Schema)

## Configuration



### Example Configuration

(blah, blah, blah)

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
