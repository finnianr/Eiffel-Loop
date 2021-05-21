note
	description: "Reflected field conforming to [$source DATE_TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 14:57:42 GMT (Friday 21st May 2021)"
	revision: "14"

class
	EL_REFLECTED_DATE_TIME

inherit
	EL_REFLECTED_REFERENCE [DATE_TIME]
		redefine
			write, reset, set_from_memory, set_from_readable, set_from_string, to_string
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): STRING_8
		do
			if attached value (a_object) as date_time then
				Result := date_time.out
			else
				create Result.make_empty
			end
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as date then
				date.make_from_epoch (0)
			end
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as dt then
				dt.date.make_by_ordered_compact_date (memory.read_integer_32)
				dt.time.make_by_compact_time (memory.read_integer_32)
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
			if attached value (a_object) as date_time then
				date_time.make_from_string_default (buffer.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as dt then
				writeable.write_integer_32 (dt.date.ordered_compact_date)
				writeable.write_integer_32 (dt.time.compact_time)
			end
		end

end