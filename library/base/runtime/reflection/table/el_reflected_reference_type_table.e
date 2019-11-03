note
	description: "Table of reflected reference fields for types conforming to `BASE_TYPE' and indexed by type_id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 11:15:59 GMT (Thursday 3rd October 2019)"
	revision: "4"

class
	EL_REFLECTED_REFERENCE_TYPE_TABLE [REFLECTED_TYPE -> EL_REFLECTED_REFERENCE [ANY], BASE_TYPE]

inherit
	EL_HASH_TABLE [TYPE [REFLECTED_TYPE], INTEGER]
		export
			{NONE} all
			{ANY} has_key, found_item, count
		redefine
			make
		end

	REFLECTOR
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

create
	make

feature {NONE} -- Initialization

	make (array: ARRAY [like as_map_list.item])
			--
		do
			Precursor (array)
			initialize
		end

	initialize
		do
			base_type_id := ({BASE_TYPE}).type_id
			type_array := current_keys
		end

feature -- Access

	base_type_id: INTEGER

	type_array: ARRAY [INTEGER]

feature -- Status query

	has_conforming (type_id: INTEGER): BOOLEAN
		do
			Result := conforming_type (type_id) > 0
		end

	has_type (type_id: INTEGER): BOOLEAN
		local
			l_type_id: INTEGER
		do
			l_type_id := conforming_type (type_id)
			if l_type_id > 0 then
				Result := has_key (l_type_id)
			end
		end

feature {NONE} -- Implementation

	conforming_type (type_id: INTEGER): INTEGER
		local
			i: INTEGER
		do
			if field_conforms_to (type_id, base_type_id) then
				from i := 1 until Result > 0 or i > type_array.count loop
					if field_conforms_to (type_id, type_array [i]) then
						Result := type_array [i]
					end
					i := i + 1
				end
			end
		end
end
