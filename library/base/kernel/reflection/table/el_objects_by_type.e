note
	description: "Lookup objects by type_id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_OBJECTS_BY_TYPE

inherit
	HASH_TABLE [ANY, INTEGER_32]

create
	make_from_array, make

feature {NONE} -- Initialization

	make_from_array (objects: ARRAY [ANY])
		do
			make_equal (objects.count)
			extend_from_array (objects)
		end

feature -- Element change

	extend_from_array (objects: ARRAY [ANY])
		do
			across objects as obj loop
				put (obj.item, obj.item.generating_type.type_id)
			end
		end
end