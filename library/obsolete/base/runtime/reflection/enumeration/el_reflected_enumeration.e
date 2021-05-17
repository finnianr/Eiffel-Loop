note
	description: "Numeric field with enumerated values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:21:16 GMT (Monday 3rd May 2021)"
	revision: "7"

deferred class
	EL_REFLECTED_ENUMERATION [N -> NUMERIC]

inherit
	EL_REFLECTED_NUMERIC_FIELD [N]
		rename
			make as make_field
		redefine
			to_string, write_crc, set_from_string
		end

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_field: EL_REFLECTED_NUMERIC_FIELD [N]; a_enumeration: like enumeration)
		do
			make_field (a_field.enclosing_object, a_field.index, a_field.name)
			enumeration := a_enumeration
		end

feature -- Access

	enumeration: EL_ENUMERATION [N]

	to_string (a_object: EL_REFLECTIVE): STRING
		do
			Result := enumeration.name (value (a_object))
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_string_general (enumeration.name (v))
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if is_numeric (string) then
				set (a_object, string_value (string))

			elseif attached {STRING} string as str_8 then
				set (a_object, enumeration.value (str_8))
			else
				set (a_object, enumeration.value (Buffer_8.copied_general (string)))
			end
		end

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			Precursor (crc)
			across enumeration.field_table as table loop
				crc.add_string_8 (table.key)
				if attached {N} table.item.value (enumeration) as enum_value then
					write_crc_value (crc, enum_value)
				end
			end
		end

feature {NONE} -- Implementation

	is_numeric (string: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: N)
		deferred
		end

end