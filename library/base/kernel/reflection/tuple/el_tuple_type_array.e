note
	description: "Array of ${TUPLE} parameter types: ${ARRAY [TYPE [ANY]]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 14:52:49 GMT (Monday 26th August 2024)"
	revision: "23"

class
	EL_TUPLE_TYPE_ARRAY

inherit
	ARRAY [TYPE [ANY]]
		rename
			make as make_array
		redefine
			make_filled
		end

	EL_MODULE_EIFFEL; EL_MODULE_CONVERT_STRING

	EL_SHARED_CLASS_ID

create
	make, make_from_static, make_from_tuple, make_empty

feature {NONE} -- Initialization

	make (type: TYPE [TUPLE])
		local
			i: INTEGER
		do
			make_filled ({INTEGER}, 1, type.generic_parameter_count)
			from i := 1 until i > count loop
				put (type.generic_parameter_type (i), i)
				i := i + 1
			end
		end

	make_filled (a_default_value: TYPE [ANY]; min_index, max_index: INTEGER)
		do
			Precursor (a_default_value, min_index, max_index)
			compare_objects
		end

	make_from_static (static_type: INTEGER)
		do
			if attached {TYPE [TUPLE]} Eiffel.type_of_type (static_type) as type then
				make (type)
			else
				make_filled ({INTEGER}, 0, 0)
			end
		end

	make_from_tuple (tuple: TUPLE)
		do
			make_from_static ({ISE_RUNTIME}.dynamic_type (tuple))
		end

feature -- Status query

	all_conform_to (a_type: TYPE [ANY]): BOOLEAN
		local
			type_id: INTEGER
		do
			type_id := a_type.type_id
			Result := across Current as type all {ISE_RUNTIME}.type_conforms_to (type.item.type_id, type_id) end
		end

	i_th_is_character_data (i: INTEGER): BOOLEAN
		do
			Result := Eiffel.is_type_in_set (area [i - 1].type_id, Class_id.Character_data_types)
		end

	is_latin_1_representable: BOOLEAN
		do
			Result := for_all (agent type_is_latin_1)
		end

	is_uniformly (type: TYPE [ANY]): BOOLEAN
		do
			Result := occurrences (type) = count
		end

feature -- Conversion

	to_type_id_array: SPECIAL [INTEGER]
		do
			create Result.make_empty (count)
			across Current as array loop
				Result.extend (array.item.type_id)
			end
		end

feature {NONE} -- Implementation

	type_is_latin_1 (type: TYPE [ANY]): BOOLEAN
		do
			Result := Convert_string.is_latin_1 (type)
		end
end