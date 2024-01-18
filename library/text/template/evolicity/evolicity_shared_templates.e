note
	description: "[
		Provides global access to the Evolicity template substitution engine.

		The templating substitution language was named "Evolicity" as a portmanteau of "Evolve" and "Felicity" 
		which is also a partial anagram of "Velocity" the Apache project which inspired it. 
		It also bows to an established tradition of naming Eiffel orientated projects starting with the letter 'E'.
	]"
	notes: "See end of page"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "10"

deferred class
	EVOLICITY_SHARED_TEMPLATES

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Evolicity_templates: EVOLICITY_TEMPLATES
			--
		once
			create Result.make
		end

note
	notes: "[
		**VARIABLE CONTEXTS**
		
		Variables which can be referenced in the template are specified by implementing the function `getter_function_table'
		in classes conforming to ${EVOLICITY_CONTEXT}. It returns a table mapping variable names to agent functions.
		
			getter_function_table: like getter_functions
					--
				do
					create Result.make (<<
						["<varible-name>",		agent some_function],
						..
					>>)
				end
			
		The return type of each agent function must conform to one of the following:

		**1.** Basic Types

		A basic type is one of: ${READABLE_STRING_GENERAL}, ${INTEGER_32_REF}, ${NATURAL_32_REF},
		${BOOLEAN_REF} or ${REAL_64_REF}

		**2.** Evolicity Context

		A type conforming to ${EVOLICITY_CONTEXT} or ${EVOLICITY_CONTEXT_IMP}
		or ${EVOLICITY_SERIALIZEABLE}. In the
		client template page, you use the standard feature call dot notation to select which object within
		the context you want to substitute into the template.
		
		**3.** An Iterable List
		
		An iterable list ${ITERABLE [G]} where `G' recursively conforms to one of the types 1 to 3.
		
		**STANDARD VARIABLES**
		
		Contexts which inherit ${EVOLICITY_SERIALIZEABLE} have a number of built-in standard variables. These are:
		
		* **encoding_name:** the output encoding for the current template. For example: `UTF-8'
		* **template_name:** the name of the current template. Internally this is of type ${FILE_PATH}.
		* **current:** the current context of the template

		**SYNTAX REFERENCE**
		
		**Variable Identifiers**
		Evolicity identifiers must start with an alphabetical character optionally followed by a string of alphanumeric or
		underscore characters. The standard way to substitute Evolicity variables into the text template is to place the 
		variable name in curly braces prefixed with the '$' symbol, for example ''foo'' or ''foo.bar'' is: `${foo}' or `${foo.bar}'.
		However if there are no identifier characters adjoining the left or right of the variable name as for example `${foo}_x',
		then this syntax may be abbreviated to just: `$foo' or `$foo.bar'
		
		**Conditional Directives**

			#if <boolean expression> then
				<directive block>
			#else
				<directive block>
			#end

		Currently only a limited range of boolean expressions are possible. A future release will implement a more complete expression parser.
		For the time being the following types of non-recursive expression are supported:

		* Numeric comparisons where a and b are numeric variables or integer constants: `$a < $b', `$a > 0', `$a = 0', `$a /= 0'
		* Logical conjunction: `<expr> and <expr>' where <expr> is a numeric comparison or boolean reference variable.
		* Logical negation: `not <expr>' where <expr> is a numeric comparison or boolean reference variable.
		* Container status: `<sequence-name>.is_empty' where ''<sequence-name>'' is a reference to an Eiffel object conforming to
		type ${SEQUENCE [G]}.

		More complicated expressions can be implemented an Eiffel function returning a boolean and then
		referenced as an Evolicity variable.

		**Iteration of ${ITERABLE [G]} containers**
		
		There are two loop syntax alternatives to iterate any object which conforms to the type ${ITERABLE [G]}
		where `G' is an object that satisfies the condition `{${EVOLICITY_CONTEXT}}.is_valid_type'.
		
		**1. foreach** loop

			#foreach $<variable-name> in $<list-name> loop
				<directive block>
			#end

		The loop index can be referenced using the implicit variable: `$loop_index'. If in addition the container
		also conforms to ${TABLE_ITERABLE [G]}, then the table key value can be referenced
		by inserting an additional variable name, separated by a comma. This is similar to Python.

			#foreach $<variable-name>, $<key-name> in $<table-name> loop
				<directive block>
			#end

		**2. across** loop

		This loop syntax imitates the Eiffel **across** syntax as follows:

			#across $<iterable-name> as $<variable-name> loop
				<directive block>
			#end

		The object referenced by `<iterable-name>' must conform to type ${ITERABLE [G]}. Exactly like in Eiffel
		you reference the item values in the directive block using the syntax `$<variable-name>.item', and the
		cursor index can be referenced as: `$<variable-name>.cursor_index'. If in addition the container also conforms to
		${TABLE_ITERABLE [G]}, then the table key value can be referenced as `$<variable-name>.key'.

		**The Evaluate Directive**

		The ''#evaluate'' directive exists to include the contents of a substituted template inside another template.
		The ''#evaluate'' directive takes two arguments, the first is a reference to a template, and the second to some
		data that can be referenced from the specified template.

		There are 4 ways to reference a template for an ''#evaluate'' directive. These are as follows

		**1.** Class template

			#evaluate ({<CLASS-NAME>}.template, $<variable-name>)

		Here `<CLASS-NAME>' must be some type which conforms to type ${EVOLICITY_SERIALIZEABLE}
		and therefore has a template. The variable in the second argument is some Eiffel data accessible
		as an Evolicity variable which is referenced by the nested template.

		**2.** Template reference
		
			#evaluate ($<variable-name>.template_name, $<variable-name>)

		Here the first argument is a reference to an object that conforms to type ${EVOLICITY_SERIALIZEABLE}
		and therefore has a template name which be referenced with the implicit variable name `template_name'.

		**3.** Template path reference

			#evaluate ($<template-variable-name>, $<variable-name>)

		Here the `<template-variable-name>' references a file path to an externally loadable template.

		You can merge nested templates in a loop using the following syntax.

			#across $<iterable-name> as $<variable-name> loop
				#evaluate ($<variable-name>.item.template_name, $<variable-name>.item)
			#end

		Here the iterable container must conform to type ${ITERABLE [EVOLICITY_SERIALIZEABLE]}. Note that even if the
		the nested text spans multiple lines, as it most likely will do, it will be indented to same indent level as
		the `#evaluate' directive.

		**4.** Quoted path string relative to template

			#evaluate ("<relative-path>", $Current)
		
		**The Include Directive**
		
			#include ($<file-path-reference>)
			OR
			#include ("<file-path>")
	
		The ''#include'' directive exists to include another file containing "static text" with no substitution code.
		The argument can be either a variable reference to a path string or a quoted path.
	]"

end