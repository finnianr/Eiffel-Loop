note
	description: "Reflected collection of Eiffel object builder contexts"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-11 12:27:55 GMT (Tuesday 11th May 2021)"
	revision: "4"

class
	EL_REFLECTED_COLLECTION_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_REFLECTED_REFERENCE [COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]]
		redefine
			is_initializeable
		end

create
	make

feature -- Access

	item_type_id: INTEGER
		-- `type_id' of `COLLECTION' item
		do
			Result := type.generic_parameter_type (1).type_id
		end

feature -- Status query

	is_initializeable: BOOLEAN
		-- `True' when possible to create an initialized instance of the field
		do
			Result := Precursor and then New_instance_table.has (item_type_id)
		end

end