note
	description: "Reflected reference type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-06-10 20:29:53 GMT (Monday 10th June 2019)"
	revision: "1"

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

	EL_MODULE_EIFFEL
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
			base_type_id := ({BASE_TYPE}).type_id
			type_array := current_keys
		end

feature -- Access

	base_type_id: INTEGER

	type_array: ARRAY [INTEGER]

feature -- Status query

	has_type (type_id: INTEGER): BOOLEAN
		local
			i, conforming_type: INTEGER
		do
			if Eiffel.field_conforms_to (type_id, base_type_id) then
				from i := 1 until conforming_type > 0 or i > type_array.count loop
					if Eiffel.field_conforms_to (type_id, type_array [i]) then
						conforming_type := type_array [i]
					end
					i := i + 1
				end
				if conforming_type > 0 then
					Result := has_key (conforming_type)
				end
			end
		end
end
