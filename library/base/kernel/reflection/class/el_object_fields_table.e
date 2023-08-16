note
	description: "Lookup reflected reference object field information by field name"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-16 10:30:45 GMT (Wednesday 16th August 2023)"
	revision: "7"

class
	EL_OBJECT_FIELDS_TABLE

inherit
	EL_IMMUTABLE_KEY_8_TABLE [INTEGER]
		rename
			found_item as found_index,
			make as make_from_array
		export
			{NONE} all
			{ANY} count, found, found_index,
				has_immutable, has_immutable_key, has_key_8, has_8, has_general, has_key_general
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_EIFFEL

	EL_SHARED_CLASS_ID; EL_SHARED_IMMUTABLE_8_MANAGER

create
	make

feature {NONE} -- Initialization

	make (a_object: ANY; prune_last_underscore, exclude_once_fields: BOOLEAN)
		-- if `prune_last_underscore' is `True' remove underscore used to distinguish field name from Eiffel keyword
		-- if `exclude_once_fields' is `True' exclude `once ("OBJECT")' field names
		local
			csv_string, field_name: STRING; i, field_count: INTEGER
			list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			dynamic_type := {ISE_RUNTIME}.dynamic_type (a_object)
			field_count := {ISE_RUNTIME}.field_count_of_type (dynamic_type)

			create csv_string.make (field_count * 30)
			from i := 1 until i > field_count loop
				if i > 1 then
					csv_string.append_character (',')
				end
				create field_name.make_from_c ({ISE_RUNTIME}.field_name_of_type (i, dynamic_type))

				-- useful for descendants of `EL_ENUMERATION [NUMERIC]' where you might want an
				-- enumeration value that clashes with an Eiffel keyword

				if prune_last_underscore and then field_name [field_name.count] = '_' then
					field_name.remove_tail (1)
				end
				csv_string.append (field_name) -- becomes a table key
				i := i + 1
			end
			csv_string.trim -- reduce area to minimum
			create list.make_shared_adjusted (csv_string, ',', 0)
			make_size (list.count)

			from list.start until list.after loop
				if attached list.item as name then
					if exclude_once_fields implies not is_once_field (name)  then
						extend (list.index, name)
					end
				end
				list.forth
			end
			create cached_field_indices_set.make_equal (3, agent new_indices_subset)
		end

feature -- Access

	dynamic_type: INTEGER

	field_indices_subset (name_list: STRING): EL_FIELD_INDICES_SET
		do
			Result := cached_field_indices_set.item (name_list)
		end

	found_static_type: INTEGER
		require
			found: found
		do
			Result := {ISE_RUNTIME}.field_static_type_of_type (found_index, dynamic_type)
		end

	found_type_info: EL_FIELD_TYPE_PROPERTIES
		require
			found: found
		do
			create Result.make (found_index, dynamic_type)
		end

feature -- Properties query

	conforming_type_info_list (type: TYPE [ANY]): SPECIAL [EL_FIELD_TYPE_PROPERTIES]
		local
			list: EL_ARRAYED_LIST [EL_FIELD_TYPE_PROPERTIES]
		do
			create list.make (count)
			control := Found_constant

			from start until after loop
				found_index := item_for_iteration
				if attached found_type_info as info and then info.conforms_to (type.type_id) then
					list.extend (info)
				end
				forth
			end
			Result := list.trimmed_area
		end

	type_info_list: SPECIAL [EL_FIELD_TYPE_PROPERTIES]
		do
			create Result.make_empty (count)
			control := Found_constant
			from start until after loop
				found_index := item_for_iteration
				Result.extend (found_type_info)
				forth
			end
		ensure
			same_count: Result.count = count
		end

feature -- Status query

	has_all_names (name_list: STRING): BOOLEAN
		local
			list: EL_SPLIT_IMMUTABLE_STRING_8_LIST
		do
			Result := True
			if name_list.count > 0 then
				create list.make_shared_adjusted (name_list, ',', {EL_SIDE}.Left)
				from list.start until list.after or not Result loop
					Result := list.item_count > 0 implies has_immutable (list.item)
					list.forth
				end
			end
		end

	has_tuple_field (name: READABLE_STRING_8): BOOLEAN
		do
			if has_key_8 (name) then
				Result := {ISE_RUNTIME}.type_conforms_to (found_static_type, Class_id.TUPLE)
			end
		end

	valid_field_names (field_list: ITERABLE [READABLE_STRING_8]): BOOLEAN
		do
			Result := across field_list as list all has_8 (list.item) end
		end

	valid_tuple_name_list (field_name, name_list: IMMUTABLE_STRING_8): BOOLEAN
		local
			field_count, static_type: INTEGER
		do
			if has_immutable_key (field_name) then
				static_type := found_static_type
				if {ISE_RUNTIME}.type_conforms_to (static_type, Class_id.TUPLE) then
					field_count := Eiffel.generic_count_of_type (static_type)
					Result := field_count = name_list.occurrences (',') + 1
				end
			end
		end

feature -- Factory

	new_subset (excluded_set: EL_FIELD_NAME_SET): SPECIAL [IMMUTABLE_STRING_8]
		-- sub-set of field names that are not in `excluded_list'
		local
			list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			create list.make (count)
			from start until after loop
				if not excluded_set.has (key_for_iteration) then
					list.extend (key_for_iteration)
				end
				forth
			end
			Result := list.trimmed_area
		end

	new_not_transient_subset (transient_list: STRING): SPECIAL [IMMUTABLE_STRING_8]
		local
			transient_set: EL_FIELD_NAME_SET; list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			create transient_set.make (transient_list)
			create list.make (count)
			control := found_constant
			from start until after loop
				found_index := item_for_iteration
				if transient_set.has (key_for_iteration) or else found_type_info.is_transient then
					do_nothing -- skip transient
				else
					list.extend (key_for_iteration)
				end
				forth
			end
			Result := list.trimmed_area
		end

feature {NONE} -- Implementation

	is_once_field (name: IMMUTABLE_STRING_8): BOOLEAN
		-- `True' if `name' is a once ("OBJECT") field name
		local
			s: EL_STRING_8_ROUTINES
		do
			Result := s.starts_with_character (name, '_')
		end

	new_indices_subset (name_list: STRING): EL_FIELD_INDICES_SET
		-- subset of field indices from `name_list'
		require
			has_all_names: has_all_names (name_list)
		local
			name_set: EL_FIELD_NAME_SET
		do
			create name_set.make (name_list)
			if name_set.count > 0 then
				create Result.make_empty_area (name_set.count)
				from name_set.start until name_set.after loop
					if has_immutable_key (name_set.iteration_item) then
						Result.area.extend (found_index)
					end
					name_set.forth
				end
			else
				Result := Empty_field_set
			end
		end

feature {NONE} -- Internal attributes

	cached_field_indices_set: EL_CACHE_TABLE [EL_FIELD_INDICES_SET, STRING]

feature {NONE} -- Constants

	Empty_field_set: EL_FIELD_INDICES_SET
		once
			create Result.make_empty
		end

invariant
	always_empty: Empty_field_set.count = 0
end