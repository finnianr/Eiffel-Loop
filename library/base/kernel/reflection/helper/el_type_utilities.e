note
	description: "[
		${SED_UTILITIES} with optimized `abstract_type' and various type property queries
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-02 18:05:05 GMT (Wednesday 2nd April 2025)"
	revision: "5"

class
	EL_TYPE_UTILITIES

inherit
	SED_UTILITIES
		rename
			abstract_type as abstract_type_of_type
		redefine
			abstract_type_of_type
		end

	EL_EIFFEL_C_API
		rename
			eif_type_flags as type_flags
		export
			{NONE} all
		end

	EL_CONTAINER_CONVERSION [ANY]

feature -- Access

	abstract_type (object: ANY): INTEGER
		do
			Result := abstract_type_of_type (dynamic_type (object))
		end

	abstract_type_of_type (a_type_id: INTEGER): INTEGER
		-- Abstract type of `a_type_id'.
		do
			Result := sparse_array_item (Abstract_type_array, a_type_id)
			inspect Result
				when {REFLECTOR_CONSTANTS}.None_type then
					Result := {REFLECTOR_CONSTANTS}.reference_type
			else
			end
		end

	abstract_type_of_type_plus (a_type_id: INTEGER): INTEGER
		-- The same as `abstract_type_of_type' except `a_type_id' might also be
		-- the reference version of an expanded type, `({NATURAL_8_REF}).type_id' for example.
		do
			Result := sparse_array_item (Abstract_type_array_plus, a_type_id)
			inspect Result
				when {REFLECTOR_CONSTANTS}.None_type then
					Result := {REFLECTOR_CONSTANTS}.reference_type
			else
			end
		end

	dynamic_type (object: separate ANY): INTEGER
		do
			Result := {ISE_RUNTIME}.dynamic_type (object)
		end

	type_flag_names (flags: NATURAL_16): EL_STRING_8_LIST
		local
			i: INTEGER
		do
			create Result.make (7)
			from i := 1 until i > Type_status_array.count loop
				if flags & (1 |<< (i + 5)).to_natural_16 > 0 then
					Result.extend (Type_status_array [i])
				end
				i := i + 1
			end
		end

feature -- Status query

	is_reference_type (type_id: INTEGER): BOOLEAN
		do
			Result := not is_type_expanded (type_flags (type_id))
		end

	is_type_in_set (type_id: INTEGER; set: SPECIAL [INTEGER]): BOOLEAN
		local
			i: INTEGER
		do
			from until i = set.count or Result loop
				Result := type_id = set [i]
				i := i + 1
			end
		end

	is_uniform_type (container: CONTAINER [ANY]): BOOLEAN
		-- `True' if items in `container' are all the same type
		local
			i, type_first: INTEGER
		do
			Result := True
			if attached as_structure (container) as structure
				and then attached structure.to_special_shared as area and then area.count > 0
			then
				type_first := dynamic_type (area [0])
				from i := 1 until i = area.count or not Result loop
					Result := dynamic_type (area [i]) = type_first
					i := i + 1
				end
			end
		end

	same_type_as (item: ANY; type_id: INTEGER): BOOLEAN
		do
			Result := dynamic_type (item) = type_id
		end

feature -- Status type flag

	is_type_composite (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_composite) > 0
		end

	is_type_dead (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_dead) > 0
		end

	is_type_declared_expanded (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_declared_expanded) > 0
		end

	is_type_deferred (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_deferred) > 0
		end

	is_type_expanded (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_expanded) > 0
		end

	is_type_frozen (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_frozen) > 0
		end

	is_type_special (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_special) > 0
		end

	is_type_tuple (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Is_tuple) > 0
		end

	type_has_dispose (flags: NATURAL_16): BOOLEAN
		do
			Result := (flags & {EL_TYPE_FLAG}.Has_dispose) > 0
		end

feature {NONE} -- Implementation

	is_reference_name_of (type_id: INTEGER; expanded_type: STRING_8): BOOLEAN
		-- `True' if `type_id' is reference version of `expanded_type'
		do
			if attached {ISE_RUNTIME}.generating_type_of_type (type_id) as ref_name
				and then ref_name.count = expanded_type.count + 4 and then ref_name.starts_with (expanded_type)
			then
				Result := ref_name.same_characters ("_REF", 1, 4, expanded_type.count + 1)
			end
		end

	new_sparse_array (map_list: EL_ARRAYED_MAP_LIST [INTEGER, INTEGER]): ARRAY [INTEGER]
		do
			map_list.sort_by_key (True)
			create Result.make_filled ({REFLECTOR_CONSTANTS}.None_type, map_list.first_key, map_list.last_key)
			across map_list as map loop
				Result [map.key] := map.value
			end
		end

	reference_type_of (abstract_type_id: INTEGER): INTEGER
		-- Eg. if `abstract_type_id' is `({BOOLEAN}).type_id' then the result
		-- is ({BOOLEAN_REF}).type_id
		local
			break: BOOLEAN; type_name: STRING_8
		do
			type_name := {ISE_RUNTIME}.generating_type_of_type (abstract_type_id)
			from Result := abstract_type_id - 1 until Result < 0 or break loop
				if {ISE_RUNTIME}.type_conforms_to (abstract_type_id, Result)
					and then is_reference_name_of (Result, type_name)
				then
					break := True
				else
					Result := Result - 1
				end
			end
		end

	sparse_array_item (array: ARRAY [INTEGER]; i: INTEGER): INTEGER
		do
			if array.valid_index (i) then
				Result := array [i]
			else
				Result := {REFLECTOR_CONSTANTS}.Reference_type
			end
		end

feature {NONE} -- Constants

	Abstract_type_array: ARRAY [INTEGER]
		-- `Special_type_mapping' as sparse array for faster lookup
		local
			map_dynamic_to_abstract: EL_ARRAYED_MAP_LIST [INTEGER, INTEGER]
		once
			create map_dynamic_to_abstract.make_from_table (Special_type_mapping)
			Result := new_sparse_array (map_dynamic_to_abstract)
		end

	Abstract_type_array_plus: ARRAY [INTEGER]
		-- `Abstract_type_array' with the addition of reference versions of basic expanded types
		-- Eg. << ({BOOLEAN_REF}).type_id, ({NATURAL_8_REF}).type_id, .. >>
		local
			map_dynamic_to_abstract: EL_ARRAYED_MAP_LIST [INTEGER, INTEGER]
			type_id: INTEGER
		once
			create map_dynamic_to_abstract.make (Special_type_mapping.count * 2)
			if attached Abstract_type_array as type then
				from type_id := type.lower until type_id > type.upper loop
					if type [type_id] /= {REFLECTOR_CONSTANTS}.None_type then
						map_dynamic_to_abstract.extend (type_id, type [type_id])
						map_dynamic_to_abstract.extend (reference_type_of (type_id), type [type_id])
					end
					type_id := type_id + 1
				end
			end
			Result := new_sparse_array (map_dynamic_to_abstract)
		end

	Type_status_array: EL_STRING_8_LIST
		once
			Result := "tuple, special, declared-expanded, expanded, has-dispose, composite, deferred, frozen, dead"
		end

end