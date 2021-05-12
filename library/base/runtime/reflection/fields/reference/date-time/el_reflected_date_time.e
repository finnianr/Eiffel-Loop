note
	description: "Reflected `DATE_TIME' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-12 10:33:36 GMT (Wednesday 12th May 2021)"
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

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached value (a_object) as date_time then
				ISO_8601_date_time.set_from_other (date_time)
				Result := ISO_8601_date_time.to_string
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

	set_from_string (a_object: EL_REFLECTIVE; general: READABLE_STRING_GENERAL)
		local
			str: STRING
		do
			str := Buffer_8.copied_general (general)
			if attached value (a_object) as date_time and then ISO_8601_date_time.is_valid_format (str) then
				ISO_8601_date_time.make (str)
				date_time.make_by_date_time (ISO_8601_date_time.date, ISO_8601_date_time.time)
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as dt then
				writeable.write_integer_32 (dt.date.ordered_compact_date)
				writeable.write_integer_32 (dt.time.compact_time)
			end
		end

feature {NONE} -- Constants

	ISO_8601_date_time: EL_ISO_8601_DATE_TIME
		once
			create Result.make_now
		end

end