note
	description: "[
		Abstraction for mapping names to code numbers with bi-directional lookups, i.e. obtain the code from
		a name and the name from a code. The generic parameter can be any [$source NUMERIC] type.
	]"
	notes: "[
		**ARRAY VS HASH_TABLE**
		
		In most cases implementing field `name_by_value: READABLE_INDEXABLE [IMMUTABLE_STRING_8]' as an
		[$source ARRAY] is both faster and has a lower memory footprint than using a [$source HASH_TABLE].
		
		Taking class [$source EL_HTTP_STATUS_ENUM] as an example:
			
			ARRAY: requires 496 bytes 
			HASH_TABLE: requires 1088 bytes
		
		**TO DO**

		A problem that needs solving is how to guard against accidental changes in
		auto-generated code values that are used persistently. One idea is to use a contract
		comparing a CRC checksum based on an alphabetical ordering to a hard coded value.

		Also there needs to be a mechanism to allow "late-editions" that will not disturb
		existing assignments.
	]"
	instructions: "See end of class"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-15 14:53:49 GMT (Tuesday 15th August 2023)"
	revision: "53"

deferred class
	EL_ENUMERATION [N -> NUMERIC]

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make
		export
			{NONE} all
			{EL_REFLECTION_HANDLER} field_table
		redefine
			make, initialize_fields, new_field_sorter
		end

	REFLECTOR_CONSTANTS
		export
			{NONE} all
		undefine
			is_equal
		end

	EL_BIT_COUNTABLE

feature {NONE} -- Initialization

	initialize_fields
			-- initialize fields with unique value
		do
			across field_table as field loop
				field.item.set_from_integer (Current, field.cursor_index)
			end
		end

	make
		local
			l_value: N; index: INTEGER; map_list: EL_ARRAYED_MAP_LIST [N, IMMUTABLE_STRING_8]
		do
			Precursor
			create map_list.make (field_table.count)
			across field_table as table loop
				if attached {like ENUM_FIELD} table.item as field then
					l_value := enum_value (field); index := as_integer (l_value)
					map_list.extend (l_value, field.export_name)
					if table.is_first then
						lower_index := index
					end
					if index < lower_index then
						lower_index := index
					end
					if upper_index < index then
						upper_index := index
					end
				end
			end
			if lower_index = 1 and upper_index = field_table.count then
				name_by_value := map_list.value_list.to_array
			else
				if physical_array_size < physical_table_size then
					name_by_value := new_name_value_array (map_list)
				else
					name_by_value := new_name_value_table (map_list)
				end
			end
		ensure then
			all_values_unique: all_values_unique
			name_and_values_consistent: name_and_values_consistent
			valid_description_keys: valid_description_keys
		end

feature -- Measurement

	count: INTEGER
		do
			Result := field_table.count
		end

feature -- Access

	description (a_value: N): ZSTRING
		do
			if description_table.has_immutable_key (field_name (a_value)) then
				Result := description_table.found_item
			else
				create Result.make_empty
			end
		end

	field_name (a_value: N): IMMUTABLE_STRING_8
		-- exported field name from field value `a_value'
		do
			if attached field_name_by_value as table and then table.has_key (as_hashable (a_value)) then
				Result := table.found_item
			else
				Result := Default_name
			end
		ensure
			not_empty: not Result.is_empty
		end

	found_value: like enum_value
		require
			found_field: found_field
		do
			if attached {like ENUM_FIELD} field_table.found_item as field then
				Result := enum_value (field)
			end
		end

	list: EL_ARRAYED_LIST [N]
		do
			create Result.make_filled (field_table.count, agent i_th_value (meta_data.field_list, ?))
		end

	name (a_value: N): IMMUTABLE_STRING_8
		-- exported name
		do
			if attached {like new_name_value_array} name_by_value as array then
				Result := array [as_integer (a_value)]

			elseif attached {like new_name_value_table} name_by_value as table
				and then table.has_key (as_hashable (a_value))
			then
				Result := table.found_item
			else
				create Result.make_empty
			end
		end

	value (a_name: READABLE_STRING_GENERAL): like enum_value
		-- enumuration value from exported `a_name'
		-- Eg. all uppercase "AUD" for `EL_CURRENCY_ENUM' returns value for field `aud: NATURAL_8'
		require
			valid_name: is_valid_name (a_name)
		do
			if has_name (a_name) then
				Result := found_value
			else
				check
					value_found: False
				end
			end
		end

feature -- Conversion

	to_compatible (a_value: NATURAL_32): N
		deferred
		end

	to_representation: EL_ENUMERATION_REPRESENTATION [N]
		-- to reflected expanded field of type `N' representing a `value' of `Current'
		do
			create Result.make (Current)
		end

feature -- Status query

	all_values_unique: BOOLEAN
		-- `True' if each enumeration field is asssigned a unique value
		local
			l_count, i: INTEGER
		do
			if attached {like new_name_value_array} name_by_value as array then
				from i := lower_index until i > upper_index loop
					if array [i].count > 1 then
						l_count := l_count + 1
					end
					i := i + 1
				end
				Result := l_count = count

			elseif attached {like new_name_value_table} name_by_value as name_by_value_table then
				Result := name_by_value_table.count = count
			end
		end

	found_field: BOOLEAN
		-- `True' if call to `has_name' or `has_field_name' finds an enumerated field
		do
			Result := field_table.found
		end

	has_field_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if has exported `a_name' and `found_value' set to value if found
		-- Eg. all lowercase "aud" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			Result := field_table.has_key_general (a_name)
		end

	has_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if has exported `a_name' and `found_value' set to value if found
		-- Eg. all uppercase "AUD" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			Result := field_table.has_imported_key (a_name)
		end

	is_valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := field_table.has_imported_key (a_name)
		end

	is_valid_value (a_value: N): BOOLEAN
		local
			i: INTEGER
		do
			if attached {like new_name_value_array} name_by_value as array then
				i := as_integer (a_value)
				if array.valid_index (i) then
					Result := array [i].count > 0
				end

			elseif attached {like new_name_value_table} name_by_value as name_by_value_table then
				Result := name_by_value_table.has (as_hashable (a_value))
			end
		end

feature -- Basic operations

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			across field_table as table loop
				if attached {like ENUM_FIELD} table.item as field then
					crc.add_string_8 (field.name)
					write_value (crc, enum_value (field))
				end
			end
		end

	write_meta_data (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		do
			output.put_indented_line (tab_count, "class " + generator)
			across field_table as table loop
				output.put_indented_line (tab_count + 1, table.item.name + " = " + table.item.to_string (Current))
			end
			output.put_indented_line (tab_count, "end")
		end

	write_value (writeable: EL_WRITABLE; a_value: N)
		deferred
		end

feature -- Contract Support

	name_and_values_consistent: BOOLEAN
		-- `True' if all `value' results can be looked up from `name_by_value' items
		local
			i: INTEGER
		do
			if attached {like new_name_value_array} name_by_value as array then
				Result := True
				from i := lower_index until i > upper_index or not Result loop
					if array [i].count > 1 then
						Result := as_integer (value (array [i])) = i
					end
					i := i + 1
				end

			elseif attached {like new_name_value_table} name_by_value as name_by_value_table then
				Result := across name_by_value_table as table all
					 table.key = as_hashable (value (table.item))
				end
			end
		end

	valid_description_keys: BOOLEAN
		do
			Result := across Description_table as table all
				field_table.has_immutable (table.key)
			end
		end

feature {NONE} -- Implementation

	field_included (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.abstract_type = enumeration_type
		end

	field_name_by_value: like new_field_name_by_value
		do
			if attached internal_field_name_by_value as table then
				Result := table
			else
				Result := new_field_name_by_value
				internal_field_name_by_value := Result
			end
		end

	i_th_value (field_list: EL_FIELD_LIST; i: INTEGER): N
		do
			if attached {like ENUM_FIELD} field_list [i] as field then
				Result := enum_value (field)
			end
		end

	new_field_name_array: ARRAY [IMMUTABLE_STRING_8]
		do
			create Result.make_filled (Default_name, lower_index, upper_index)
		end

	new_field_name_by_value: HASH_TABLE [IMMUTABLE_STRING_8, like as_hashable]
		do
			create Result.make (count)
			across field_table as table loop
				if attached {like ENUM_FIELD} table.item as field then
					Result.extend (field.name, as_hashable (enum_value (field)))
				end
			end
		end

	new_field_sorter: like Default_field_order
		do
			create Result.make_default
			Result.set_alphabetical_sort
		end

	new_name_value_array (
		map_list: EL_ARRAYED_MAP_LIST [N, IMMUTABLE_STRING_8]
	): ARRAY [IMMUTABLE_STRING_8]
		local
			i: INTEGER
		do
			create Result.make_filled (Default_name, lower_index, upper_index)
			across map_list as map loop
				i := as_integer (map.key)
				check
					no_conflict: Result [i].count = 0
				end
				Result [i] := map.value
			end
		end

	new_name_value_table (
		map_list: EL_ARRAYED_MAP_LIST [N, IMMUTABLE_STRING_8]
	): HASH_TABLE [IMMUTABLE_STRING_8, like as_hashable]
		do
			create Result.make_equal (map_list.count)
			across map_list as map loop
				Result.put (map.value, as_hashable (map.key))
				check
					no_conflict: not Result.conflict
				end
			end
		end

	physical_array_size: INTEGER
		local
			trial_array: ARRAY [BOOLEAN]
		do
			create trial_array.make_filled (False, lower_index, upper_index)
			Result := Eiffel.deep_physical_size (trial_array)
		end

	physical_table_size: INTEGER
		local
			trial_table: HASH_TABLE [BOOLEAN, like as_hashable]
		do
			create trial_table.make (field_table.count)
			Result := Eiffel.deep_physical_size (trial_table)
		end

feature {NONE} -- Deferred

	ENUM_FIELD: EL_REFLECTED_INTEGER_FIELD [NUMERIC]
		-- Type definition
		require
			never_called: False
		deferred
		end

	as_hashable (a_value: N): HASHABLE
		deferred
		end

	as_integer (n: N): INTEGER
		deferred
		end

	enum_value (field: like ENUM_FIELD): N
		deferred
		end

	enumeration_type: INTEGER
		deferred
		end

feature {NONE} -- Internal attributes

	internal_field_name_by_value: detachable like new_field_name_by_value

	lower_index: INTEGER

	name_by_value: READABLE_INDEXABLE [IMMUTABLE_STRING_8]
		-- exported name table by value

	upper_index: INTEGER

feature {NONE} -- Constants

	Default_name: IMMUTABLE_STRING_8
		once
			create Result.make_empty
		end

	Description_table: EL_IMMUTABLE_UTF_8_TABLE
		-- table of descriptions by exported name
		-- redefine to add descriptions
		once
			create Result.make_empty
		end

note
	instructions: "[
		Typically you would make a shared instance of an implementation class inheriting
		this class.

		Overriding ''import_name'' from [$source EL_REFLECTIVELY_SETTABLE] allows you to lookup
		a code using a foreign naming convention, camelCase, for example. Overriding
		''export_name'' allows the name returned by `code_name' to use a foreign convention.
		Choose a convention from the ''Naming'' object.
	]"
	descendants: "[
			EL_ENUMERATION* [N -> NUMERIC]
				[$source EL_ENUMERATION_NATURAL_16]*
					[$source EL_IPAPI_CO_JSON_FIELD_ENUM]
					[$source EL_HTTP_STATUS_ENUM]
				[$source EL_ENUMERATION_NATURAL_8]*
					[$source EL_NETWORK_DEVICE_TYPE_ENUM]
					[$source EL_BOOLEAN_ENUMERATION]*
						[$source PP_ADDRESS_STATUS_ENUM]
					[$source PP_PAYMENT_STATUS_ENUM]
					[$source PP_PAYMENT_PENDING_REASON_ENUM]
					[$source PP_TRANSACTION_TYPE_ENUM]
					[$source EL_CURRENCY_ENUM]
					[$source TL_PICTURE_TYPE_ENUM]
					[$source AIA_RESPONSE_ENUM]
					[$source AIA_REASON_ENUM]
					[$source TL_MUSICBRAINZ_ENUM]
					[$source TL_FRAME_ID_ENUM]
					[$source TL_STRING_ENCODING_ENUM]
					[$source EROS_ERRORS_ENUM]
				[$source EL_ENUMERATION_NATURAL_32]*
					[$source EVOLICITY_TOKEN_ENUM]
	]"

end -- class EL_ENUMERATION