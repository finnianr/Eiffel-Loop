note
	description: "Reflected field factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 7:12:40 GMT (Monday 5th May 2025)"
	revision: "5"

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

	new_item (a_object: ANY; a_index: INTEGER; a_name: IMMUTABLE_STRING_8): G
		do
			create Result.make (a_object, a_index, a_name)
		end

feature {NONE} -- Implementation

	new_default_item: G
		do
		end

end