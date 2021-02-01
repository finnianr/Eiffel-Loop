note
	description: "Reflected date time"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-01 12:28:48 GMT (Monday 1st February 2021)"
	revision: "11"

class
	EL_REFLECTED_DATE_TIME

inherit
	EL_REFLECTED_READABLE [DATE_TIME]
		redefine
			write, reset, set_from_readable, set_from_string, to_string
		end

create
	make

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
			if attached value (a_object) as date then
				date.make_from_epoch (0)
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
			writeable.write_date_time (value (a_object))
		end

end