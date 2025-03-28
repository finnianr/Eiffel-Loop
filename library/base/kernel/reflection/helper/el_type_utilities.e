note
	description: "${SED_UTILITIES} with optimized `abstract_type'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-28 8:39:00 GMT (Friday 28th March 2025)"
	revision: "2"

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

feature -- Access

	abstract_type (object: ANY): INTEGER
		do
			Result := abstract_type_of_type ({ISE_RUNTIME}.dynamic_type (object))
		end

	abstract_type_of_type (a_type_id: INTEGER): INTEGER
		-- Abstract type of `a_type_id'.
		do
			if attached Abstract_type_array as array and then array.valid_index (a_type_id) then
				Result := array [a_type_id]
				if Result = 0 then
					Result := {REFLECTOR_CONSTANTS}.reference_type
				end
			else
				Result := {REFLECTOR_CONSTANTS}.reference_type
			end
		end

	dynamic_type (object: separate ANY): INTEGER
		do
			Result := {ISE_RUNTIME}.dynamic_type (object)
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

feature {NONE} -- Constants

	Abstract_type_array: ARRAY [INTEGER]
		-- `Special_type_mapping' as sparse array for faster lookup
		local
			map_dynamic_to_abstract: EL_ARRAYED_MAP_LIST [INTEGER, INTEGER]
		once
			create map_dynamic_to_abstract.make_from_table (Special_type_mapping)
			map_dynamic_to_abstract.sort_by_key (True)
			create Result.make_filled (0, map_dynamic_to_abstract.first_key, map_dynamic_to_abstract.last_key)
			across map_dynamic_to_abstract as map loop
				Result [map.key] := map.value
			end
		end

end