note
	description: "[
		A reflected type `N' conforming to [$source NUMERIC] representing a [$source EL_ENUMERATION [N]]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 9:37:28 GMT (Monday 14th August 2023)"
	revision: "10"

class
	EL_ENUMERATION_REPRESENTATION [N -> NUMERIC]

inherit
	EL_STRING_FIELD_REPRESENTATION [N, EL_ENUMERATION [N]]
		rename
			item as enumeration
		redefine
			append_to_string, write_crc
		end

	EL_REFLECTION_HANDLER

create
	make

feature {NONE} -- Initialization

	make (a_enumeration: like enumeration)
		do
			enumeration := a_enumeration
		end

feature -- Access

	to_string (a_value: like to_value): STRING
		do
			Result := enumeration.name (a_value)
		end

feature -- Basic operations

	append_comment (field_definition: STRING)
		-- append comment to meta data `field_definition'
		do
			field_definition.append (" -- Enumeration: " + enumeration.generator)
		end

	append_to_string (a_value: like to_value; str: ZSTRING)
		do
			if enumeration.is_valid_value (a_value) then
				str.append_string_general (enumeration.name (a_value))
			else
				enumeration.write_value (str, a_value)
			end
		end

	to_value (a_name: READABLE_STRING_GENERAL): N
		do
			if a_name.is_natural_32 then
				Result := enumeration.to_compatible (a_name.to_natural_32)

			else
				Result := enumeration.value (a_name)
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			enumeration.write_crc (crc)
		end

end