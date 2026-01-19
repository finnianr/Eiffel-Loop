note
	description: "Table of reflected reference fields for types conforming to `BASE_TYPE' and indexed by type_id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-11 10:26:22 GMT (Sunday 11th December 2022)"
	revision: "7"

class
	EL_REFLECTED_REFERENCE_TYPE_TABLE [REFLECTED_TYPE -> EL_REFLECTED_REFERENCE [ANY]]

inherit
	EL_HASH_TABLE [TYPE [REFLECTED_TYPE], INTEGER]
		rename
			make as make_from_array
		export
			{NONE} all
			{ANY} has_key, found_item, count
		end

	REFLECTOR
		export
			{NONE} all
		undefine
			is_equal, copy, default_create
		end

	EL_MODULE_EIFFEL

create
	make

feature {NONE} -- Initialization

	make (array: ARRAY [TYPE [REFLECTED_TYPE]])
			--
		local
			generic_type: TYPE [ANY]
		do
			make_size (array.count)
			across array as reflected loop
				if reflected.item.generic_parameter_count = 1 then
					extend (reflected.item, reflected.item.generic_parameter_type (1).type_id)

				elseif attached {REFLECTED_TYPE} Eiffel.new_instance_of (reflected.item.type_id) as field then
					generic_type := field.value_type
					extend (reflected.item, generic_type.type_id)
				end
			end
			initialize
		end

	initialize
		do
			base_type_id := new_base_type_id
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

	new_base_type_id: INTEGER
		local
			reflected_type: TYPE [REFLECTED_TYPE]
		do
			reflected_type := {REFLECTED_TYPE}
			if reflected_type.generic_parameter_count = 1 then
				Result := reflected_type.generic_parameter_type (1).type_id
			elseif attached {REFLECTED_TYPE} Eiffel.new_instance_of (reflected_type.type_id) as type then
				Result := type.value_type.type_id
			end
		end

end
