note
	description: "Reflected field of type [$source TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-09 11:24:45 GMT (Friday 9th December 2022)"
	revision: "20"

class
	EL_REFLECTED_TIME

inherit
	EL_REFLECTED_TEMPORAL [TIME]
		rename
			valid_string as valid_format
		redefine
			reset, set_from_memory, set_from_string, write, valid_format
		end

create
	make

feature -- Basic operations

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

	upgraded (time: TIME): EL_TIME
		-- upgrade `TIME' to `EL_TIME'
		do
			Result := EL_time
			Result.make_by_fine_seconds (time.fine_seconds)
		end

feature {NONE} -- Constants

	EL_time: EL_TIME
		once
			create Result.make (0, 0, 0)
		end

end