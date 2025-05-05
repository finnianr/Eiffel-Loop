note
	description: "Factory for objects of type ${EL_REFLECTED_COLLECTION [G]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 7:06:44 GMT (Monday 5th May 2025)"
	revision: "5"

class
	EL_REFLECTED_COLLECTION_FACTORY [G, R -> EL_REFLECTED_COLLECTION [G] create make, default_create end]

inherit
	EL_FACTORY [R]

feature -- Access

	new_field (a_object: ANY; a_index: INTEGER_32; a_name: IMMUTABLE_STRING_8): R
		do
			create Result.make (a_object, a_index, a_name)
		end

	new_item: R
		do
			create Result
		end
end