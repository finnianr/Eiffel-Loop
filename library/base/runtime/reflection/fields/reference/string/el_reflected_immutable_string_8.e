note
	description: "Reflected field of type [$source IMMUTABLE_STRING_8]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-07-25 5:23:01 GMT (Monday 25th July 2022)"
	revision: "9"

class
	EL_REFLECTED_IMMUTABLE_STRING_8

inherit
	EL_REFLECTED_STRING [IMMUTABLE_STRING_8]
		redefine
			set_from_string_general
		end

create
	make

feature -- Basic operations

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached Buffer_8.empty as str then
				memory.read_into_string_8 (str)
				set_from_string_general (a_object, str)
			end
		end

	set_from_string_general (a_object: EL_REFLECTIVE; general: READABLE_STRING_GENERAL)
		local
			new: IMMUTABLE_STRING_8
		do
			if attached {IMMUTABLE_STRING_8} general as str then
				set (a_object, str)
			else

				set (a_object, create {IMMUTABLE_STRING_8}.make_from_string (general.to_string_8))
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set (a_object, readable.read_string_8)
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_WRITEABLE)
		do
			writeable.write_string_8 (value (a_object))
		end

	write_to_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			memory.write_string_8 (value (a_object))
		end

feature {NONE} -- Implementation

	reset (a_object: EL_REFLECTIVE)
		-- do nothing because `string' is immutable
		do
		end

	set_string (string: IMMUTABLE_STRING_8; general: READABLE_STRING_GENERAL)
		-- do nothing because `string' is immutable
		do
		end

end