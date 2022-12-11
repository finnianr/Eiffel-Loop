note
	description: "Reflected field factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-11 17:20:29 GMT (Sunday 11th December 2022)"
	revision: "3"

class
	EL_REFLECTED_FIELD_FACTORY [G -> EL_REFLECTED_FIELD create make end]

inherit
	EL_FACTORY [EL_REFLECTED_FIELD]
		rename
			new_item as new_default_item
		export
			{NONE} all
		end

feature -- Factory

	new_item (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: STRING): G
		do
			create Result.make (a_object, a_index, a_name)
		end

feature {NONE} -- Implementation

	new_default_item: G
		do
		end

end