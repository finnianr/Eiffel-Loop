note
	description: "Summary description for {EL_REFLECTED_CHARACTER_32}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-02 18:50:20 GMT (Wednesday 2nd May 2018)"
	revision: "5"

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

	to_string (a_object: EL_REFLECTIVELY_SETTABLE): STRING_32
		local
			str: STRING_32
		do
			str := empty_once_string_32
			str.extend (value (a_object))
			Result := str.twin
		end

feature -- Basic operations

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
