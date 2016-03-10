note
	description: "Summary description for {EL_TYPE_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-04 8:15:04 GMT (Thursday 4th July 2013)"
	revision: "2"

class
	EL_TYPE_TABLE [BASE_TYPE, G]

inherit
	HASH_TABLE [G, INTEGER]
		rename
			item as type_item,
			remove as remove_function
		end

	EL_MODULE_TYPING
		undefine
			is_equal, copy
		end

create
	make

feature -- Access

	item (object: BASE_TYPE; creation_function: FUNCTION [BASE_TYPE, TUPLE, like type_item]): like type_item
			--
		local
			type_id: INTEGER
		do
			type_id := Typing.dynamic_type (object)
			search (type_id)
			if found then
				Result := found_item
			else
				Result := creation_function.item ([])
				extend (Result, type_id)
			end
		end

feature -- Removal

	remove (object: BASE_TYPE)
		do
			remove_function (Typing.dynamic_type (object))
		end
end
