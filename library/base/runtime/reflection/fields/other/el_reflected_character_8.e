note
	description: "Summary description for {EL_REFLECTED_CHARACTER_8}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-02 18:50:32 GMT (Wednesday 2nd May 2018)"
	revision: "5"

class
	EL_REFLECTED_CHARACTER_8

inherit
	EL_REFLECTED_EXPANDED_FIELD [CHARACTER_8]
		rename
			field_value as character_8_field
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVELY_SETTABLE): STRING_8
		local
			str: STRING_8
		do
			str := empty_once_string_8
			str.extend (value (a_object))
			Result := str.twin
		end

feature -- Basic operations

	set (a_object: EL_REFLECTIVE; a_value: CHARACTER_8)
		do
			enclosing_object := a_object
			set_character_8_field (index, a_value)
		end

	set_from_readable (a_object: EL_REFLECTIVE; a_value: EL_READABLE)
		do
			set (a_object, a_value.read_character_8)
		end

	set_from_integer (a_object: EL_REFLECTIVE; a_value: INTEGER)
		do
			set (a_object, a_value.to_character_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.is_empty then
				set (a_object, '%U')
			else
				set (a_object, string.item (1).to_character_8)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_character_8 (value (a_object))
		end

end
