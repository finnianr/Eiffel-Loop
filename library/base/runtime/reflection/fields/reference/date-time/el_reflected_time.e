note
	description: "Reflected field of type [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-14 18:56:44 GMT (Saturday 14th August 2021)"
	revision: "18"

class
	EL_REFLECTED_TIME

inherit
	EL_REFLECTED_REFERENCE [TIME]
		rename
			valid_string as valid_format
		redefine
			append_to_string, write, reset, set_from_memory, set_from_readable, set_from_string, to_string,
			valid_format
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached value (a_object) as time then
				Result := time.out
			end
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as time and then attached converted (time) as l_time then
				l_time.append_to (str, l_time.default_format_string)
			end
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as time then
				time.copy (time.origin)
			end
		end

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as time then
				time.make_by_compact_time (memory.read_integer_32)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached value (a_object) as time then
				time.make_from_string_default (Buffer_8.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as time then
				writeable.write_integer_32 (time.compact_time)
			end
		end

feature -- Contract Support

	valid_format (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value (a_object) as time then
				Result := time.time_valid (Buffer_8.copied_general (string), time.default_format_string)
			end
		end

feature {NONE} -- Implementation

	converted (time: TIME): like EL_time
		do
			if attached {EL_TIME} time as l_time then
				Result := l_time
			else
				Result := EL_time
				Result.make_by_fine_seconds (time.fine_seconds)
			end
		end

feature {NONE} -- Constants

	EL_time: EL_TIME
		once
			create Result.make (0, 0, 0)
		end

end