note
	description: "Lookup objects by type_id"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
