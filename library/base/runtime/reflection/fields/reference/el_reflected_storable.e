note
	description: "[
		Storable object that use object reflection to read and write fields and compare objects.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-02-13 13:48:15 GMT (Saturday 13th February 2021)"
	revision: "10"

class
	EL_REFLECTED_STORABLE

inherit
	EL_REFLECTED_REFERENCE [EL_STORABLE]
		redefine
			 write, to_string, set_from_string, set_from_memory
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

	set_from_memory (a_object: EL_REFLECTIVE; memory: EL_MEMORY_READER_WRITER)
		do
			value (a_object).read (memory)
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