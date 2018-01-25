note
	description: "Summary description for {EL_REFLECTED_DATE_TIME}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-24 12:36:40 GMT (Wednesday 24th January 2018)"
	revision: "3"

class
	EL_REFLECTED_DATE_TIME

inherit
	EL_REFLECTED_READABLE
		redefine
			default_value, write, set_from_readable, set_from_string
		end

create
	make

feature -- Basic operations

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		local
			new_date_time: DATE_TIME; date_time: DATE_TIME
		do
			if attached {DATE_TIME} default_value as l_date_time then
				new_date_time := l_date_time.twin
				date_time := reader.read_date_time
				new_date_time.set_date (date_time.date)
				new_date_time.set_time (date_time.time)
				set (a_object, new_date_time)
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, readable.read_string_8)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			new_date_time: DATE_TIME
		do
			if attached {like default_value} default_value as l_date_time then
				new_date_time := l_date_time.twin
				new_date_time.make_from_string_default (string.to_string_8)
				set (a_object, new_date_time)
			end
		end

	write (a_object: EL_REFLECTIVELY_SETTABLE; writeable: EL_MEMORY_READER_WRITER)
		do
			writeable.write_date_time (value (a_object))
		end

feature {NONE} -- Internal attributes

	default_value: detachable DATE_TIME

end
