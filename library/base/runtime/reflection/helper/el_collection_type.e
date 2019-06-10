note
	description: "Collection type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 17:48:08 GMT (Monday 10th June 2019)"
	revision: "1"

class
	EL_COLLECTION_TYPE [G]

inherit
	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			type_id := ({COLLECTION [G]}).type_id
			reflected_field_type := {EL_REFLECTED_COLLECTION [G]}
		end

feature -- Conversion

	to_tuple: TUPLE [INTEGER, like reflected_field_type]
		do
			Result := [type_id, reflected_field_type]
		end

feature {NONE} -- Internal attributes

	reflected_field_type: TYPE [EL_REFLECTED_COLLECTION [G]]

	type_id: INTEGER

end
