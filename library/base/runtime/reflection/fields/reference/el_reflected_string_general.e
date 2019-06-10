note
	description: "Field that conforms to `STRING_GENERAL'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 14:16:50 GMT (Monday 10th June 2019)"
	revision: "6"

class
	EL_REFLECTED_STRING_GENERAL

inherit
	EL_REFLECTED_REFERENCE [STRING_GENERAL]
		redefine
			Default_objects, reset, set_from_readable, set_from_string, to_string, write
		end

	EL_STRING_32_CONSTANTS

	EL_ZSTRING_CONSTANTS

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			Result := value (a_object)
		end

feature -- Status query

	is_zstring: BOOLEAN
		do
			Result := type_id = String_z_type
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			value (a_object).keep_head (0)
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		local
			id: INTEGER
		do
			id := type_id
			if id = String_z_type then
				set (a_object, readable.read_string)
			elseif id = String_8_type then
				set (a_object, readable.read_string_8)
			elseif id = String_32_type then
				set (a_object, readable.read_string_32)
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			l_value: like value
		do
			l_value := value (a_object)
			l_value.keep_head (0);
			if attached {ZSTRING} l_value as z_str then
				z_str.append_string_general (string)
			elseif attached {ZSTRING} string as z_str then
				l_value.append (z_str.to_string_32)
			else
				l_value.append (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_general (value (a_object))
		end

feature {NONE} -- Constants

	Default_objects: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<< Empty_string, Empty_string_8, Empty_string_32 >>)
		end

end
