note
	description: "Reflected field factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-25 13:38:27 GMT (Saturday 25th January 2020)"
	revision: "1"

class
	EL_REFLECTED_FIELD_FACTORY [G -> EL_REFLECTED_FIELD create make end]

feature -- Factory

	new_item (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING): G
		do
			create Result.make (a_object, a_index, a_name)
		end
end
