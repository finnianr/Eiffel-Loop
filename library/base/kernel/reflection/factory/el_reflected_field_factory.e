note
	description: "Reflected field factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 11:30:57 GMT (Monday 14th August 2023)"
	revision: "4"

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

	new_item (a_object: EL_REFLECTIVE; a_index: INTEGER; a_name: IMMUTABLE_STRING_8): G
		do
			create Result.make (a_object, a_index, a_name)
		end

feature {NONE} -- Implementation

	new_default_item: G
		do
		end

end