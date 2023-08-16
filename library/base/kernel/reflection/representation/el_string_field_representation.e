note
	description: "[
		A field value `G' that represents an item of type `H' capable of conversion to and from
		a string conforming to [$source READABLE_STRING_GENERAL].
	]"
	notes: "[
		See `representation' attribute in class
		[$source EL_REFLECTED_EXPANDED_FIELD [G]] and `new_representations' function in class [$source EL_REFLECTIVE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 9:37:46 GMT (Monday 14th August 2023)"
	revision: "9"

deferred class
	EL_STRING_FIELD_REPRESENTATION [G, H]

inherit
	EL_FIELD_REPRESENTATION [G, H]

	EL_MODULE_CONVERT_STRING

feature -- Access

	to_string (a_value: like to_value): READABLE_STRING_GENERAL
		deferred
		end

feature -- Basic operations

	append_to_string (a_value: like to_value; str: ZSTRING)
		do
			str.append_string_general (to_string (a_value))
		end

	to_value (str: READABLE_STRING_GENERAL): G
		deferred
		end

feature {NONE} -- Constants

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

end