note
	description: "Reflected field conforming to [$source DATE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "19"

class
	EL_REFLECTED_DATE

inherit
	EL_REFLECTED_REFERENCE [DATE]
		redefine
			append_to_string, reset, set_from_memory, set_from_readable, set_from_string, to_string, write
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

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as date and then attached converted (date) as l_date then
				l_date.append_to (str, l_date.default_format_string)
			end
		end

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
		do
			if attached value (a_object) as date then
				date.make_from_string_default (Buffer_8.copied_general (string))
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

feature {NONE} -- Implementation

	converted (date: DATE): like EL_date
		do
			if attached {EL_DATE} date as l_date then
				Result := l_date
			else
				Result := EL_date
				Result.make_by_ordered_compact_date (date.ordered_compact_date)
			end
		end

feature {NONE} -- Constants

	EL_date: EL_DATE
		once
			create Result.make (1, 1, 1)
		end

end