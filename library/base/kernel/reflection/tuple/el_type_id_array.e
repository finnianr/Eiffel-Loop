note
	description: "Array of dynamic type identifiers"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-31 12:04:00 GMT (Monday 31st July 2023)"
	revision: "1"

class
	EL_TYPE_ID_ARRAY

inherit
	ARRAY [INTEGER]
		rename
			make as make_sized
		end

create
	make, make_from_tuple

feature {NONE} -- Initialization

	make (type_array: EL_TUPLE_TYPE_ARRAY)
		local
			i: INTEGER
		do
			make_filled (0, 1, type_array.count)
			from i := 1 until i > count loop
				put (type_array [i].type_id, i)
				i := i + 1
			end
		end

	make_from_tuple (tuple: TUPLE)
		do
			make (create {EL_TUPLE_TYPE_ARRAY}.make_from_tuple (tuple))
		end

feature -- Status query

	has_conforming (object: ANY): BOOLEAN
			-- `True' if object conforms to one of `Current' types
		local
			type_id, i: INTEGER
		do
			type_id := {ISE_RUNTIME}.dynamic_type (object)
			if attached area as l_area then
				from until Result or i = l_area.count  loop
					Result := {ISE_RUNTIME}.type_conforms_to (type_id, l_area [i])
					i := i + 1
				end
			end
		end
end