note
	description: "[
		Dynamic module API function pointers.		
		This class automates the process of assigning shared object (DLL) API function pointers to
		pointer attributes.
	]"

	instructions: "[
		To use this class, define a descendant and define a pointer attribute for each API function.
		The attibute must be named to match the API name with any common prefix stripped from the beginning.
		A common prefix is defined by creating a descendant of `EL_DYNAMIC_MODULE' and defining a value for
		`name_prefix'. The name of the C function will be automatically inferred from the attribute names
		
		In the `make' routine these pointer attributes will be automatically initialized, by inferring the
		C function names from the attribute names using object reflection.
		
		**Reserved Words**
		
		If the C function name happens to coincide with an Eiffel reserved word, `create' for example, the attribute
		name can be tweaked with addition of an underscore, `create_' in this example. This will resolve any compilation
		problems. The C function name will still be correctly inferred.
		
		**Upper case letters**
		
		Any C function names that happen to contain uppercase characters, must be explicitly listed by redefining
		the array function `function_names_with_upper'. This is because Eiffel identifers are case-insensitive and
		the object reflection always returns the name in lowercase.

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-24 11:28:28 GMT (Saturday 24th September 2016)"
	revision: "2"

class
	EL_DYNAMIC_MODULE_POINTERS

inherit
	EL_REFLECTION

	EL_MODULE_EXCEPTION

create
	make

feature {NONE} -- Initialization

	make (module: EL_DYNAMIC_MODULE [EL_DYNAMIC_MODULE_POINTERS])
		-- Assumes that any pointer fields starting with "pointer_" correspond to an
		-- API function name and that the remainder of the field name is the same as the
		-- API name without the prefix defined by `name_prefix'

		-- since Eiffel identifiers are case insensitive, C API identifiers with upper case characters must be
		-- listed by overriding the function `function_names_with_upper'
		local
			object: REFLECTED_REFERENCE_OBJECT
			i, field_count: INTEGER; name: STRING; function: POINTER
			names_with_upper: EL_HASH_TABLE [STRING, STRING]
		do
			create names_with_upper.make_equal (11)
			across function_names_with_upper as upper_name loop
				names_with_upper [upper_name.item.as_lower] := upper_name.item
			end
			object := Once_current_object; current_object.set_object (Current)
			field_count := current_object.field_count
			from i := 1 until i > field_count loop
				if object.field_type (i) = Pointer_type then
					name := object.field_name (i)
					name.prune_all_trailing ('_') -- Remove underscore used to distinguish function name from Eiffel reserved words
					names_with_upper.search (name)
					if names_with_upper.found then
						name := names_with_upper.found_item
					end
					function := module.function_pointer (name)
					if function = Default_pointer then
						Exception.raise_developer (
							"API initialization error. No such C routine %"%S%S%" in class %S",
							[module.name_prefix, name, generator]
						)
					else
						object.set_pointer_field (i, function)
					end
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	function_names_with_upper: ARRAY [STRING]
		-- List any C API names that contain uppercase characters in descendant
		-- but strip the names of the general prefix defined by `name_prefix'
		do
			create Result.make_empty
		end

end
