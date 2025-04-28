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
	date: "2025-04-28 17:10:17 GMT (Monday 28th April 2025)"
	revision: "79"

deferred class
	EL_ENUMERATION [N -> HASHABLE]

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

	EL_ENUMERATION_TEXT [N]
		rename
			new_interval_table as new_interval_hash_table
		undefine
			is_equal
		redefine
			valid_table_keys
		end

	EL_BIT_COUNTABLE

	EL_OBJECT_PROPERTY_I

feature {NONE} -- Initialization

	initialize_fields
			-- initialize fields with unique value
		do
			if attached new_table_text as table_text then
				set_utf_8_text (table_text)
				if table_text.is_empty then
					interval_table := default_interval_table
				else
					interval_table := new_interval_table
				end
			end
			if values_in_text and attached field_list as field then
				across interval_table.key_list as list loop
					field [list.cursor_index].set_from_integer (Current, as_integer (list.item))
					text_value_count := text_value_count + 1
				end
			else
				across field_list as list loop
					list.item.set_from_integer (Current, list.cursor_index)
				end
			end
		ensure then
			each_description_has_code: values_in_text implies text_value_count = count
		end

	make
		require else
			valid_enum_type: valid_enum_type
		local
			name_table: EL_HASH_TABLE [like ENUM_FIELD, N]
		do
			Precursor
			create name_table.make (count)
			across field_list as list loop
				if attached {like ENUM_FIELD} list.item as field then
					name_table.extend (field, field_value (field))
				end
			end
			field_by_value_table := new_field_by_value_table (name_table)
		ensure then
			all_values_unique: all_values_unique
			name_and_values_consistent: name_and_values_consistent
			valid_text_table_keys: valid_table_keys
		end

feature -- Measurement

	count: INTEGER
		do
			Result := field_list.count
		end

	text_value_count: INTEGER
		-- count of values in string manifest text `new_table_text' that match those in `field_list'

feature -- Access

	as_list: EL_ARRAYED_RESULT_LIST [like ENUM_FIELD, N]
		do
			create Result.make (field_by_value_table, agent field_value)
			Result.sort (True)
		end

	field_name (a_value: N): IMMUTABLE_STRING_8
		-- field `name' from field value `a_value'
		do
			Result := lookup_name (a_value, False)
		ensure
			not_empty: not Result.is_empty
		end

	found_value: like field_value
		require
			found_field: found_field
		do
			if attached {like ENUM_FIELD} field_table.found_item as field then
				Result := field_value (field)
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

	value (a_name: READABLE_STRING_GENERAL): like field_value
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

	found_field: BOOLEAN
		-- `True' if call to `has_name' or `has_field_name' finds an enumerated field
		do
			Result := field_table.found
		end

	has_field_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `field_table' has `a_name' and `found_value' set to value if found
		-- Eg. all lowercase "aud" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			Result := field_table.has_key_general (a_name)
		end

	has_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `field_table' has exported `a_name' and `found_value' set to value if found
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
				Result := name_table.has (a_value)
			end
		end

feature -- Basic operations

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			across field_list as list loop
				if attached {like ENUM_FIELD} list.item as field then
					crc.add_string_8 (field.name)
					write_value (crc, field_value (field))
				end
			end
		end

	write_meta_data (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		do
			output.put_indented_line (tab_count, "class " + generator)
			across field_list as list loop
				output.put_indented_line (tab_count + 1, list.item.name + " = " + list.item.to_string (Current))
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
			Result := across field_by_value_table as table all
				 table.key = value (table.item.export_name)
			end
		end

	valid_enum_type: BOOLEAN
		do
			Result := Eiffel.abstract_type_of_type (({N}).type_id) = enum_type
		end

	valid_table_keys: BOOLEAN
		do
			Result := values_in_text implies count = interval_table.count
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
			if attached field_by_value_table as table and then table.has_key (a_value) then
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

	default_interval_table: EL_SPARSE_ARRAY_TABLE [INTEGER_64, N]
		deferred
		end

	enum_type: INTEGER
		deferred
		end

	field_value (field: like ENUM_FIELD): N
		deferred
		end

	new_field_by_value_table (table: HASH_TABLE [like ENUM_FIELD, N]): EL_SPARSE_ARRAY_TABLE [like ENUM_FIELD, N]
		deferred
		end

	new_interval_table: like default_interval_table
		deferred
		end

	new_table_text: READABLE_STRING_GENERAL
		deferred
		end

feature {NONE} -- Internal attributes

	field_by_value_table: like new_field_by_value_table

	interval_table: like default_interval_table
		-- map code to description substring compact interval

feature {NONE} -- Constants

	Default_name: IMMUTABLE_STRING_8
		once ("PROCESS")
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