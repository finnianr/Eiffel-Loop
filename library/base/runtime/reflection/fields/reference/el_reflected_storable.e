note
	description: "Reflected field conforming to type [$source EL_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-21 14:59:18 GMT (Friday 21st May 2021)"
	revision: "11"

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