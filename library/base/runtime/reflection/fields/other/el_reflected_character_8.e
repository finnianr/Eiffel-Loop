note
	description: "Reflected character 8"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-30 11:38:08 GMT (Friday 30th April 2021)"
	revision: "13"

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

	to_string (a_object: EL_REFLECTIVE): STRING_8
		do
			create Result.make_filled (value (a_object), 1)
		end

	reference_value (a_object: EL_REFLECTIVE): like value.to_reference
		do
			create Result
			Result.set_item (value (a_object))
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