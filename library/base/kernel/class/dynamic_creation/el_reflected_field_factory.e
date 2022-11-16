note
	description: "Reflected field factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_REFLECTED_FIELD_FACTORY [G -> EL_REFLECTED_FIELD create make end]

feature -- Factory

	new_item (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING): G
		do
			create Result.make (a_object, a_index, a_name)
		end
end