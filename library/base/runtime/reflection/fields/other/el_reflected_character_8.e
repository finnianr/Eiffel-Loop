note
	description: "Reflected [$source CHARACTER_8] field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-17 13:43:58 GMT (Monday 17th May 2021)"
	revision: "16"

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

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_character_8 (value (a_object))
		end

feature {NONE} -- Implementation

	append (string: STRING_GENERAL; a_value: CHARACTER)
		do
			string.append_code (a_value.natural_32_code)
		end

	append_directly (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_character_8 (v)
			end
		end

	append_indirectly (a_object: EL_REFLECTIVE; str: ZSTRING; any_ref: ANY)
		do
		end

	set_indirectly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL; a_representation: ANY)
		do
		end

	set_directly (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if string.is_empty then
				set (a_object, '%U')
			else
				set (a_object, string.item (1).to_character_8)
			end
		end

	to_string_directly (a_object: EL_REFLECTIVE): STRING_8
		do
			create Result.make_filled (value (a_object), 1)
		end

	to_string_indirectly (a_object: EL_REFLECTIVE; a_representation: ANY): STRING
		do
		end

end