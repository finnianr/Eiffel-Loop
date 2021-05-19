note
	description: "[
		An expanded field value `G' that represents an item of type `H' capable of conversion to and from
		a string conforming to [$source READABLE_STRING_GENERAL]. See `representation' attribute in class
		[$source EL_REFLECTED_EXPANDED_FIELD [G]] and `new_representations' function in class [$source EL_REFLECTIVE]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 8:51:12 GMT (Wednesday 19th May 2021)"
	revision: "3"

deferred class
	EL_STRING_REPRESENTATION [G, H]

feature -- Access

	item: H
		-- instance of type `H' that `value' represents

	to_string (a_value: like to_value): READABLE_STRING_GENERAL
		deferred
		end

	expanded_type: TYPE [ANY]
		do
			Result := {G}
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		deferred
		end

	append_to_string (a_value: like to_value; str: ZSTRING)
		do
			str.append_string_general (to_string (a_value))
		end

	to_value (str: READABLE_STRING_GENERAL): G
		deferred
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			crc.add_string_8 (item.generator)
		end

feature {NONE} -- Constants

	Buffer_8: EL_STRING_8_BUFFER
		once
			create Result
		end

end