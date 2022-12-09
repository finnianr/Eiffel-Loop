note
	description: "Reflection information for type conforming to [$source COLLECTION [G]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EL_COLLECTION_TYPE [G]

inherit
	EL_MAKEABLE

create
	make

feature {EL_REFLECTED_COLLECTION_TYPE_TABLE} -- Initialization

	make
		do
			item_type_id := ({G}).type_id
			type_id := ({COLLECTION [G]}).type_id
			reflected_type := {EL_REFLECTED_COLLECTION [G]}
		end

feature -- Access

	item_type_id: INTEGER

	reflected_type: TYPE [EL_REFLECTED_COLLECTION [G]]

	type_id: INTEGER

end