note
	description: "Reflected date"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-01 12:27:35 GMT (Monday 1st February 2021)"
	revision: "11"

class
	EL_REFLECTED_DATE

inherit
	EL_REFLECTED_READABLE [DATE]
		redefine
			write, reset, set_from_readable, set_from_string, to_string
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached value (a_object) as date then
				Result := date.out
			end
		end

feature -- Basic operations

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		do
			set (a_object, reader.read_date)
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as date then
				date.copy (date.origin)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if attached value (a_object) as date then
				date.make_from_string_default (buffer.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_MEMORY_READER_WRITER)
		do
			writeable.write_date (value (a_object))
		end

end