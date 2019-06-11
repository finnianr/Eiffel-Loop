note
	description: "Collection type association"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-11 14:42:28 GMT (Tuesday 11th June 2019)"
	revision: "2"

class
	EL_COLLECTION_TYPE_ASSOCIATION [G]

feature {EL_REFLECTED_COLLECTION_TYPE_TABLE} -- Initialization

	make
		do
			type_id := ({COLLECTION [G]}).type_id
			reflected_field_type := {EL_REFLECTED_COLLECTION [G]}
		end

feature -- Access

	reflected_field_type: TYPE [EL_REFLECTED_COLLECTION [G]]

	type_id: INTEGER

end
