note
	description: "Reflected field conforming to [$source DATE_TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 7:52:00 GMT (Thursday 8th December 2022)"
	revision: "20"

class
	EL_REFLECTED_DATE_TIME

inherit
	EL_REFLECTED_REFERENCE [DATE_TIME]
		rename
			valid_string as valid_format
		redefine
			append_to_string, write, reset, new_factory,
			set_from_memory, set_from_readable, set_from_string, to_string,
			valid_format
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

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as dt and then attached converted (dt) as date_time then
				date_time.append_to (str, date_time.default_format_string)
			end
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as date_time then
				date_time.make_from_epoch (0)
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
		do
			if attached value (a_object) as date_time then
				date_time.make_from_string_default (Buffer_8.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writeable: EL_MEMORY_READER_WRITER)
		do
			if attached value (a_object) as dt then
				writeable.write_integer_32 (dt.date.ordered_compact_date)
				writeable.write_integer_32 (dt.time.compact_time)
			end
		end

feature -- Contract Support

	valid_format (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL): BOOLEAN
		do
			if attached value (a_object) as date_time then
				Result := date_time.date_time_valid (Buffer_8.copied_general (string), date_time.default_format_string)
			end
		end

feature {NONE} -- Implementation

	converted (date_time: DATE_TIME): like EL_date_time
		do
			if attached {EL_DATE_TIME} date_time as dt then
				Result := dt
			else
				Result := EL_date_time
				Result.set_from_other (date_time)
			end
		end

	new_factory: detachable EL_FACTORY [DATE_TIME]
		do
			if attached {EL_FACTORY [DATE_TIME]} Date_time_factory.new_item_factory (type_id) as f then
				Result := f
			else
				Result := Precursor
			end
		end

feature {NONE} -- Constants

	EL_date_time: EL_DATE_TIME
		once
			create Result.make_from_epoch (0)
		end
end