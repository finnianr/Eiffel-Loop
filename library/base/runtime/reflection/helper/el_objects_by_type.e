note
	description: "Lookup objects by type_id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-26 8:20:23 GMT (Thursday 26th April 2018)"
	revision: "1"

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
