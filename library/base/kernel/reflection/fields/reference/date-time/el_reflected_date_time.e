note
	description: "Reflected field conforming to [$source DATE_TIME]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-26 10:33:08 GMT (Monday 26th December 2022)"
	revision: "25"

class
	EL_REFLECTED_DATE_TIME

inherit
	EL_REFLECTED_TEMPORAL [DATE_TIME]
		rename
			valid_string as valid_format
		redefine
			are_equal, write, reset, new_factory, set_from_memory, set_from_string, valid_format
		end

	EL_TIME_ROUTINES
		export
			{NONE} all
		undefine
			is_equal
		end

create
	make

feature -- Basic operations

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
				set_from_compact_decimal (dt.time, read_compressed_time (memory))
			end
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached value (a_object) as date_time then
				date_time.make_from_string_default (Buffer_8.copied_general (string))
			end
		end

	write (a_object: EL_REFLECTIVE; writable: EL_WRITABLE)
		do
			if attached value (a_object) as dt then
				writable.write_integer_32 (dt.date.ordered_compact_date)
				write_compressed_time (dt.time, writable)
			end
		end

feature -- Comparison

	are_equal (a_current, other: EL_REFLECTIVE): BOOLEAN
		do
			if attached value (a_current) as dt_1 then
				if attached value (other) as dt_2
					and then dt_1.date.ordered_compact_date = dt_2.date.ordered_compact_date
				then
					Result := same_time (dt_1.time, dt_2.time)
				end
			else
--				Both void
				Result := not attached value (other)
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

	new_factory: detachable EL_FACTORY [DATE_TIME]
		do
			if attached {EL_FACTORY [DATE_TIME]} Date_time_factory.new_item_factory (type_id) as f then
				Result := f
			else
				Result := Precursor
			end
		end

	upgraded (date_time: DATE_TIME): EL_DATE_TIME
		-- upgrade `DATE_TIME' to `EL_DATE_TIME'
		do
			Result := EL_date_time
			Result.set_from_other (date_time)
		end

feature {NONE} -- Constants

	EL_date_time: EL_DATE_TIME
		once
			create Result.make_from_epoch (0)
		end

end