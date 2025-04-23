note
	description: "[
		Abstraction for mapping names to code numbers with bi-directional lookups, i.e. obtain the code from
		a name and the name from a code. The generic parameter can be any ${NUMERIC} type.
	]"
	notes: "[
		**ARRAY VS HASH_TABLE**
		
		In most cases implementing field `name_by_value: READABLE_INDEXABLE [IMMUTABLE_STRING_8]' as an
		${ARRAY} is both faster and has a lower memory footprint than using a ${HASH_TABLE}.
		
		Taking class ${EL_HTTP_STATUS_ENUM} as an example:
			
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
	date: "2025-04-23 13:48:39 GMT (Wednesday 23rd April 2025)"
	revision: "75"

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

	EL_OBJECT_PROPERTY_I

feature {NONE} -- Initialization

	initialize_fields
			-- initialize fields with unique value
		local
			code_string: ZSTRING; space_index: INTEGER
		do
			if codes_in_description and then attached description_table as table then
				create code_string.make_empty
				across field_list as list loop
					code_string.wipe_out
					if attached {EL_REFLECTED_NUMERIC_FIELD [N]} list.item as field
						and then table.has_immutable_key (field.name) and then attached table.found_item as l_description
					then
						space_index := l_description.index_of (' ', 1)
						if space_index > 0 then
							code_string.append_substring (l_description, 1, space_index - 1)
							if code_string.is_integer then
								field.set_from_integer (Current, code_string.to_integer)
								code_found_count := code_found_count + 1
							end
						end
					end
				end
			else
				across field_table as field loop
					field.item.set_from_integer (Current, field.cursor_index)
				end
			end
		ensure then
			each_description_has_code: codes_in_description implies code_found_count = field_list.count
		end

	make
		local
			name_table: EL_HASH_TABLE [like ENUM_FIELD, like as_hashable]
		do
			Precursor
			create name_table.make (field_table.count)
			across field_table as table loop
				if attached {like ENUM_FIELD} table.item as field then
					name_table.extend (field, as_hashable (enum_value (field)))
				end
			end
			field_by_value_table := new_field_by_value_table (name_table)
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

	as_list: EL_ARRAYED_LIST [N]
		do
			create Result.make (field_table.count)
			if attached field_by_value_table as table then
				from table.start until table.after loop
					Result.extend (enum_value (table.item_for_iteration))
					table.forth
				end
				Result.sort (True)
			end
		end

	description (a_value: N): ZSTRING
		do
			if description_table.has_immutable_key (field_name (a_value)) then
				Result := description_table.found_item
			else
				create Result.make_empty
			end
		end

	field_name (a_value: N): IMMUTABLE_STRING_8
		-- field `name' from field value `a_value'
		do
			Result := lookup_name (a_value, False)
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

	name (a_value: N): IMMUTABLE_STRING_8
		-- field `exported_name' from field value `a_value'
		do
			Result := lookup_name (a_value, True)
		end

	name_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			if attached {like name_list} as_list.derived_list (agent name) as list then
				Result := list
			else
				create Result.make_empty
			end
		end

	value (a_name: READABLE_STRING_GENERAL): like enum_value
		-- enumuration value from exported `a_name'
		-- Eg. all uppercase "AUD" for `EL_CURRENCY_ENUM' returns value for field `aud: NATURAL_8'
		require
			valid_name: valid_name (a_name)
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
		do
			if attached field_by_value_table as name_table then
				Result := name_table.count = count
			end
		end

	codes_in_description: BOOLEAN
		-- `True' if enumeration values are found in the `description_table' as the first
		-- word of each description.
		do
			Result := False
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

	valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := field_table.has_imported_key (a_name)
		end

	valid_value (a_value: N): BOOLEAN
		do
			if attached field_by_value_table as name_table then
				Result := name_table.has (as_hashable (a_value))
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
		do
			if attached field_by_value_table as name_table then
				Result := across name_table as table all
					 table.key = as_hashable (value (table.item.export_name))
				end
			end
		end

	valid_description_keys: BOOLEAN
		do
			Result := across description_table as table all
				field_table.has_immutable (table.key)
			end
		end

feature {NONE} -- Implementation

	field_included (field: EL_FIELD_TYPE_PROPERTIES): BOOLEAN
		do
			Result := field.abstract_type = enum_type
		end

	lookup_name (a_value: N; exported: BOOLEAN): IMMUTABLE_STRING_8
		-- exported name
		do
			Result := Default_name
			if attached field_by_value_table as table and then table.has_key (as_hashable (a_value)) then
				if exported then
					Result := table.found_item.export_name
				else
					Result := table.found_item.name
				end
			end
		end

feature {NONE} -- Factory

	new_field_sorter: like Default_field_order
		do
			create Result.make_default
			Result.set_alphabetical_sort
		end

feature {NONE} -- Deferred

	ENUM_FIELD: EL_REFLECTED_INTEGER_FIELD [NUMERIC]
		-- Type definition
		deferred
		end

	as_hashable (a_value: N): HASHABLE
		deferred
		end

	description_table: EL_IMMUTABLE_UTF_8_TABLE
		-- table of descriptions by exported name
		-- rename to `no_descriptions' if not required
		deferred
		end

	enum_type: INTEGER
		deferred
		end

	enum_value (field: like ENUM_FIELD): N
		deferred
		end

	new_field_by_value_table (
		table: HASH_TABLE [like ENUM_FIELD, like as_hashable]

	): EL_SPARSE_ARRAY_TABLE [like ENUM_FIELD, like as_hashable]
		deferred
		end

feature {NONE} -- Internal attributes

	field_by_value_table: like new_field_by_value_table

	code_found_count: INTEGER

feature {NONE} -- Constants

	Default_name: IMMUTABLE_STRING_8
		once ("PROCESS")
			create Result.make_empty
		end

	frozen No_descriptions: EL_IMMUTABLE_UTF_8_TABLE
		-- table of descriptions by exported name
		-- redefine to add descriptions
		once
			create Result.make_empty
		end

note
	instructions: "[
		Typically you would make a shared instance of an implementation class inheriting
		this class.

		Overriding ''import_name'' from ${EL_REFLECTIVELY_SETTABLE} allows you to lookup
		a code using a foreign naming convention, camelCase, for example. Overriding
		''export_name'' allows the name returned by `code_name' to use a foreign convention.
		Choose a convention from the ''Naming'' object.
	]"
	descendants: "[
			EL_ENUMERATION* [N -> NUMERIC]
				${EL_ENUMERATION_NATURAL_16*}
					${EL_HTTP_STATUS_ENUM}
					${EL_IPAPI_CO_JSON_FIELD_ENUM}
					${EL_SERVICE_PORT_ENUM}
					${EL_FTP_SERVER_REPLY_ENUM}
				${EL_ENUMERATION_NATURAL_8*}
					${TL_PICTURE_TYPE_ENUM}
					${EL_NETWORK_DEVICE_TYPE_ENUM}
					${TL_FRAME_ID_ENUM}
					${TL_MUSICBRAINZ_ENUM}
					${TL_STRING_ENCODING_ENUM}
					${EL_BOOLEAN_ENUMERATION*}
						${PP_ADDRESS_STATUS_ENUM}
					${PP_PAYMENT_STATUS_ENUM}
					${PP_PAYMENT_PENDING_REASON_ENUM}
					${PP_TRANSACTION_TYPE_ENUM}
					${EL_CURRENCY_ENUM}
					${EL_DOC_TEXT_TYPE_ENUM}
					${AIA_RESPONSE_ENUM}
					${AIA_REASON_ENUM}
					${EROS_ERRORS_ENUM}
					${PP_L_VARIABLE_ENUM}
				${EL_ENUMERATION_NATURAL_32*}
					${EVC_TOKEN_ENUM}
	]"

end -- class EL_ENUMERATION