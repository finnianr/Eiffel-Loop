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
	date: "2025-04-30 12:26:01 GMT (Wednesday 30th April 2025)"
	revision: "82"

deferred class EL_ENUMERATION [N -> HASHABLE] inherit ANY

	EL_ENUMERATION_TEXT [N]
		rename
			new_interval_table as new_interval_hash_table
		undefine
			is_equal
		redefine
			valid_table_keys
		end

	EL_BIT_COUNTABLE

feature {NONE} -- Initialization

	initialize
		do
		end

	initialize_fields (field_list: EL_FIELD_LIST)
		-- initialize fields with unique value
		do
			if values_in_text and attached field_list.table as l_field_table then
				across interval_table as table loop
					if attached field_name_for_interval (table.item, utf_8_text) as l_name then
						if l_field_table.has_immutable_key (l_name)
							and then attached l_field_table.found_item as field
						then
							field.set_from_integer (Current, as_integer (table.key))
							text_value_count := text_value_count + 1
						end
					end
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
		require
			valid_enum_type: valid_enum_type
		local
			l_name_table: HASH_TABLE [IMMUTABLE_STRING_8, N]
		do
		 	if attached new_field_list as field_list then
			-- obtain values from text table before call to `initialize_fields'
				if attached new_table_text as table_text then
					set_utf_8_text (table_text)
					if table_text.is_empty then
						interval_table := default_interval_table
					else
						interval_table := new_interval_table (field_list)
					end
				end
			 	count := field_list.count
				initialize_fields (field_list)
				create l_name_table.make (field_list.count)
				across field_list as list loop
					if attached {EL_REFLECTED_INTEGER_FIELD [NUMERIC]} list.item as field then
						l_name_table.put (field.name, as_enum (field.to_natural_64 (Current).to_integer_32))
					end
				end
		 	end
			field_name_table := new_field_name_table (l_name_table)
		ensure
			all_values_unique: all_values_unique
			name_and_values_consistent: name_and_values_consistent
			valid_text_table_keys: valid_table_keys
		end

feature -- Measurement

	count: INTEGER note option: transient attribute end

	text_value_count: INTEGER note option: transient attribute end
		-- count of values in string manifest text `new_table_text' that match those in `field_list'
		-- (set as transient so as not to be included as an enumeration value)

feature -- Access

	as_list: EL_ARRAYED_LIST [N]
		do
			Result := field_name_table.key_list
			Result.sort (True)
		end

	field_name (a_value: N): IMMUTABLE_STRING_8
		-- field `name' from field value `a_value'
		do
			if field_name_table.has_key (a_value) then
				Result := field_name_table.found_item
			else
				Result := Empty_text
			end
		ensure
			not_empty: not Result.is_empty
		end

	found_value: like as_enum note option: transient attribute end
		-- value set after all to `has_field_name' or `has_name'
		-- (set as transient so as not to be included as an enumeration value)

	name (a_value: N): IMMUTABLE_STRING_8
		-- field `exported_name' from field value `a_value'
		do
			if attached name_translater as translater then
				if attached name_table as table and then table.has_key (a_value) then
					Result := table.found_item
				else
					Result := Empty_text
				end
			else
				Result := field_name (a_value)
			end
		end

	name_list: EL_ARRAYED_LIST [IMMUTABLE_STRING_8]
		do
			if attached {like name_list} as_list.derived_list (agent name) as list then
				Result := list
			else
				create Result.make_empty
			end
		end

	value (a_name: READABLE_STRING_GENERAL): like as_enum
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
			Result := field_name_table.count = count
		end

	found_field: BOOLEAN
		-- `True' if call to `has_name' or `has_field_name' finds an enumerated field

	has_field_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `field_table' has `a_name' and `found_value' set to value if found
		-- Eg. all lowercase "aud" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			if attached value_table as table and then table.has_key (as_name_key (a_name)) then
				Result := True
				found_value := table.found_item
			else
				found_value := as_enum (0)
			end
			found_field := Result
		end

	has_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if `field_table' has exported `a_name' and `found_value' set to value if found
		-- Eg. all uppercase "AUD" for `EL_CURRENCY_ENUM' sets value for field `aud: NATURAL_8'
		do
			if name_translater = Void then
				Result := has_field_name (a_name)

			elseif attached value_by_name_table as table then
				if table.has_key (as_name_key (a_name)) then
					found_value := table.found_item
					Result := True

				elseif attached translated_key (a_name) as key then
					if value_table.has_key (key) then
						found_value := value_table.found_item
						Result := True
						table.extend (found_value, key)
					end
				end
			end
			found_field := Result
		end

	valid_name (a_name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if name_translater = Void then
				Result := value_table.has (as_name_key (a_name))

			elseif attached value_by_name_table as table then
				if table.has (as_name_key (a_name)) then
					Result := True
				else
					Result := value_table.has (translated_key (a_name))
				end
			end
		end

	valid_value (a_value: N): BOOLEAN
		do
			Result := field_name_table.has (a_value)
		end

feature -- Basic operations

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			across field_name_table as table loop
				crc.add_string_8 (table.item)
				write_value (crc, table.key)
			end
		end

	write_meta_data (output: EL_OUTPUT_MEDIUM; tab_count: INTEGER)
		do
			output.put_indented_line (tab_count, "class " + generator)
			across new_field_list as list loop
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
			if attached name_translater as translater then
				Result := across field_name_table as table all
					table.key = value (translater.exported (table.item))
				end
			else
				Result := across field_name_table as table all
					table.key = value (table.item)
				end
			end
		end

	valid_enum_type: BOOLEAN
		do
			inspect enum_type
				when integer_8_type, Integer_16_type, Integer_32_type then
					Result := True
				when Natural_8_type, Natural_16_type, Natural_32_type then
					Result := True
			else
			end
		end

	valid_table_keys: BOOLEAN
		do
			Result := values_in_text implies count = interval_table.count
		end

feature {NONE} -- Implementation

	as_name_key (a_name: READABLE_STRING_GENERAL): IMMUTABLE_STRING_8
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			Result := Immutable_8.as_shared (sg.as_readable_string_8 (a_name))
		end

	enum_type: INTEGER
		do
			Result := Eiffel.abstract_type_of_type (({N}).type_id)
		end

	name_table: like field_name_table
		local
			l_name_table: HASH_TABLE [IMMUTABLE_STRING_8, N]
		do
			if attached internal_name_table as table then
				Result := table

			elseif attached name_translater as translater then
				create l_name_table.make (field_name_table.count)
				across field_name_table as table loop
					l_name_table.extend (translater.exported (table.item), table.key)
				end
				Result := new_field_name_table (l_name_table)
				internal_name_table := Result
			end
		end

	new_field_list: EL_FIELD_LIST
		do
			create Result.make_abstract (Current, enum_type, True)
			Result.order_by (agent {EL_REFLECTED_FIELD}.name, True) -- Important for `write_crc'
		end

	value_by_name_table: EL_HASH_TABLE [N, IMMUTABLE_STRING_8]
		local
			exported_names: EL_CSV_STRING_8; i: INTEGER
		do
			if attached internal_value_by_name_table as table then
				Result := table
			else
				if attached name_translater as translater then
					create exported_names.make (field_name_table.count * 20)
					across field_name_table as table loop
						exported_names.extend (translater.exported (table.item))
					end
					create Result.make (field_name_table.count)
					if attached exported_names.to_immutable_list as l_name_list then
						across field_name_table as table loop
							i := i + 1
							Result.extend (table.key, l_name_list.i_th (i))
						end
					end
				else
					create Result.make (0)
				end
				internal_value_by_name_table := Result
			end
		end

	value_table: EL_HASH_TABLE [N, IMMUTABLE_STRING_8]
		do
			if attached internal_value_table as table then
				Result := table
			else
				create Result.make (field_name_table.count)
				across field_name_table as table loop
					Result.extend (table.key, table.item)
				end
				internal_value_table := Result
			end
		end

feature {NONE} -- Deferred

	default_interval_table: EL_SPARSE_ARRAY_TABLE [INTEGER_64, N]
		deferred
		end

	new_field_name_table (table: HASH_TABLE [IMMUTABLE_STRING_8, N]): EL_SPARSE_ARRAY_TABLE [IMMUTABLE_STRING_8, N]
		deferred
		end

	new_interval_table (field_list: EL_FIELD_LIST): like default_interval_table
		deferred
		end

feature {NONE} -- Internal attributes

	field_name_table: like new_field_name_table
		-- lookup name by value

	internal_name_table: detachable like field_name_table

	internal_value_by_name_table: like value_by_name_table

	internal_value_table: like value_table

	interval_table: like default_interval_table;
		-- map code to description substring compact interval

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