note
	description: "[
		A reflected type `N' conforming to [$source NUMERIC] representing a [$source EL_ENUMERATION [N]]]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 12:18:32 GMT (Friday 9th December 2022)"
	revision: "6"

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
			str.append_string_general (enumeration.name (a_value))
		end

	to_value (str: READABLE_STRING_GENERAL): N
		do
			if attached {STRING} str as string_8 then
				Result := enumeration.value (string_8.to_string_8)
			else
				Result := enumeration.value (Buffer_8.copied_general (str))
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			across enumeration.field_table as table loop
				crc.add_string_8 (table.key)
				if attached {N} table.item.value (enumeration) as enum_value then
					if attached {NATURAL_8} enum_value as natural_8 then
						crc.add_natural_8 (natural_8)
					elseif attached {NATURAL_16} enum_value as natural_16 then
						crc.add_natural_16 (natural_16)
					else
						check
							added_to_crc: False
						end
					end
				end
			end
		end

end