note
	description: "Reflected field conforming to [$source DATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 15:37:10 GMT (Friday 21st May 2021)"
	revision: "15"

class
	EL_REFLECTED_DATE

inherit
	EL_REFLECTED_REFERENCE [DATE]
		redefine
			write, reset, set_from_memory, set_from_readable, set_from_string, to_string
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

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as date then
				date.copy (date.origin)
			end
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as date then
				date.make_by_ordered_compact_date (memory.read_integer_32)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		require else
			valid_format: valid_format (a_object, string.to_string_8)
		local
			buffer: EL_STRING_8_BUFFER_ROUTINES
		do
			if attached value (a_object) as date then
				date.make_from_string_default (buffer.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as date then
				writeable.write_integer_32 (date.ordered_compact_date)
			end
		end

feature -- Contract Support

	valid_format (a_object: EL_REFLECTIVE; string: STRING): BOOLEAN
		do
			if attached value (a_object) as date then
				Result := date.date_valid (string, date.default_format_string)
			end
		end
end