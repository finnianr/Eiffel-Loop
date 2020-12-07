note
	description: "Numeric field with enumerated values"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-07 12:33:52 GMT (Monday 7th December 2020)"
	revision: "1"

deferred class
	EL_REFLECTED_ENUMERATION [N -> NUMERIC]

inherit
	EL_REFLECTED_NUMERIC_FIELD [N]
		rename
			make as make_field
		redefine
			to_string, write_crc
		end

feature {EL_CLASS_META_DATA} -- Initialization

	make (a_object: ANY; a_index: INTEGER; a_name: STRING; a_enumeration: EL_ENUMERATION [N])
		do
			if attached {EL_REFLECTIVE} a_object as reflective then
				make_field (reflective, a_index, a_name)
				enumeration := a_enumeration
			end
		end

feature -- Access

	enumeration: EL_ENUMERATION [N]

	to_string (a_object: EL_REFLECTIVE): STRING
		do
			Result := enumeration.name (value (a_object))
		end

feature -- Basic operations

	set_from_string (a_object: EL_REFLECTIVELY_SETTABLE; string: READABLE_STRING_GENERAL)
		do
			if not is_numeric (string) then
				set (a_object, enumeration_value (string))
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

	enumeration_value (string: READABLE_STRING_GENERAL): like value
		do
			if attached {STRING} string as str_8 then
				Result := enumeration.value (str_8)
			else
				Result := enumeration.value (once_general_copy_8 (string))
			end
		end

	write_crc_value (crc: EL_CYCLIC_REDUNDANCY_CHECK_32; enum_value: N)
		deferred
		end

end