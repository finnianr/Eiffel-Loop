note
	description: "[
		Storable object that use object reflection to read and write fields and compare objects.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-25 16:16:02 GMT (Wednesday 25th April 2018)"
	revision: "5"

class
	EL_REFLECTED_STORABLE

inherit
	EL_REFLECTED_READABLE [EL_STORABLE]
		redefine
			 write, print_meta_data, to_string, set_from_string
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		local
			l_value: EL_STORABLE
		do
			l_value :=  value (a_object)
			if attached {EL_MAKEABLE_FROM_STRING_GENERAL} l_value as makeable then
				Result := makeable.to_string
			else
				Result := l_value.out
			end
		end

feature -- Basic operations

	print_meta_data (a_object: EL_REFLECTIVE; lio: EL_LOGGABLE; i: INTEGER; last: BOOLEAN)
		do
			Precursor (a_object, lio, i, True)
			lio.tab_right; lio.tab_right
			lio.put_new_line
			value (a_object).print_meta_data (lio)
			lio.tab_left; lio.tab_left
			if not last then
				lio.put_new_line
			end
		end

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		do
			value (a_object).read (reader)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_MAKEABLE_FROM_STRING_GENERAL} value (a_object) as makeable then
				makeable.make_from_general (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writer: EL_MEMORY_READER_WRITER)
		do
			value (a_object).write (writer)
		end

end
