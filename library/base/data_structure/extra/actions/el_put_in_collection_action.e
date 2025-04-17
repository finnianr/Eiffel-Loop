note
	description: "Action to put an item into a container conforming to ${COLLECTION}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 11:53:42 GMT (Wednesday 16th April 2025)"
	revision: "1"

class
	EL_PUT_IN_COLLECTION_ACTION [G]

inherit
	EL_CONTAINER_ACTION [G]

create
	make

feature {NONE} -- Initialization

	make (a_collection: like collection)
		do
			collection := a_collection
		end

feature -- Basic operations

	do_with (item: G)
		do
			collection.put (item)
		end

feature {NONE} -- Internal attributes

	collection: COLLECTION [G]
end