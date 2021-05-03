note
	description: "Reflected character 32"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-03 13:19:07 GMT (Monday 3rd May 2021)"
	revision: "13"

class
	EL_REFLECTED_CHARACTER_32

inherit
	EL_REFLECTED_EXPANDED_FIELD [CHARACTER_32]
		rename
			field_value as character_32_field
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING_32
		local
			str: STRING_32; buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			str := buffer.empty
			str.extend (value (a_object))
			Result := str.twin
		end

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_character (v)
			end
		end

	set (a_object: EL_REFLECTIVE; a_value: CHARACTER_32)
		do
			enclosing_object := a_object
			set_character_32_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_character_32)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_character_32)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.is_empty then
				set (a_object, '%U')
			else
				set (a_object, string.item (1).to_character_32)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_character_32 (value (a_object))
		end

end