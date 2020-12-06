note
	description: "[
		Storable object that use object reflection to read and write fields and compare objects.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-06 11:35:14 GMT (Sunday 6th December 2020)"
	revision: "9"

class
	EL_REFLECTED_STORABLE

inherit
	EL_REFLECTED_READABLE [EL_STORABLE]
		redefine
			 write, to_string, set_from_string
		end

create
	make

feature -- Access

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		local
			l_value: EL_STORABLE
		do
			l_value :=  value (a_object)
			if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} l_value as makeable then
				Result := makeable.to_string
			else
				Result := l_value.out
			end
		end

feature -- Basic operations

	read (a_object: EL_REFLECTIVE; reader: EL_MEMORY_READER_WRITER)
		do
			value (a_object).read (reader)
		end

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		do
			if attached {EL_MAKEABLE_FROM_STRING [STRING_GENERAL]} value (a_object) as makeable then
				makeable.make_from_general (string)
			end
		end

	write (a_object: EL_REFLECTIVE; writer: EL_MEMORY_READER_WRITER)
		do
			value (a_object).write (writer)
		end

end