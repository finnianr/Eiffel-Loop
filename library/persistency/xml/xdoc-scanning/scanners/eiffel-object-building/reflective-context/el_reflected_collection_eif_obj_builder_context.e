note
	description: "Reflected collection eif obj builder context"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 14:07:03 GMT (Monday 10th June 2019)"
	revision: "2"

class
	EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]]

create
	make

feature -- Access

	item_type_id: INTEGER
		do
			Result := Eiffel.type_of_type (type_id).generic_parameter_type (1).type_id
		end

end
