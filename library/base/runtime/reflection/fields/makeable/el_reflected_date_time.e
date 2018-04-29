note
	description: "Summary description for {EL_REFLECTED_DATE_TIME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 15:42:08 GMT (Saturday 28th April 2018)"
	revision: "4"

class
	EL_REFLECTED_DATE_TIME

inherit
	EL_REFLECTED_READABLE
		rename
			default_value as default_date_time
		redefine
			default_date_time, default_defined, write, reset,
			set_from_readable, set_from_string, initialize_default, to_string
		end

create
	make

feature -- Status query

	default_defined: BOOLEAN
		do
			if not Default_value_table.has (type_id) and then date_types.has (type_id) then
				Result := True
			end
		end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		local
			date_time: like value
		do
			date_time := value (a_object)
			if attached {EL_DATE_TIME} date_time as dt then
				Result := dt.to_string
			else
				Result := date_time.out
			end
		end

feature -- Basic operations

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		local
			dt, date_time: DATE_TIME
		do
			date_time := value (a_object)
			dt := reader.read_date_time
			date_time.set_date (dt.date)
			date_time.set_time (dt.time)
		end

	reset (a_object: EL_REFLECTIVE)
		do
			if attached {DATE_TIME} value (a_object) as date then
				date.make_from_epoch (0)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached default_date_time then
				default_date_time.make_from_string_default (string.to_string_8)
			end
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_MEMORY_READER_WRITER)
		do
			writeable.write_date_time (value (a_object))
		end

feature {NONE} -- Implementation

	initialize_default
		local
			types: like Date_types
		do
			types := Date_types
			if types.has_key (type_id) and then attached {DATE_TIME} types.found_item as date_time then
				default_date_time := date_time
			end
		end

feature {NONE} -- Internal attributes

	default_date_time: detachable DATE_TIME

feature {NONE} -- Constants

	Date_types: EL_OBJECTS_BY_TYPE
		once
			create Result.make_from_array (<<
				create {DATE_TIME}.make_now,
				create {EL_DATE_TIME}.make_now,
				create {EL_ISO_8601_DATE_TIME}.make_now,
				create {EL_SHORT_ISO_8601_DATE_TIME}.make_now
			>>)
		end

end
