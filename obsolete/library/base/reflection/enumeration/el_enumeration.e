note
	description: "[
		Object for mapping names to code numbers with bi-directional lookups, i.e. obtain the code from
		a name and the name from a code. The generic parameter can be any [$source NUMERIC] type.
	]"
	notes: "[
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
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "47"

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
			make, initialize_fields, field_order
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as field_name_by_value,
			new_item as new_field_name_by_value
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS

feature {NONE} -- Initialization

	initialize_fields
			-- initialize fields with unique value
		do
			across field_table as field loop
				field.item.set_from_integer (Current, field.cursor_index)
			end
		end

	make
		do
			field_type_id := ({N}).type_id.to_character_32
			Precursor
			create name_by_value.make (field_table.count)
			across field_table as field loop
				if attached {HASHABLE} field.item.value (Current) as key then
					name_by_value.put (field.item.export_name, key)
					check
						no_conflict: not name_by_value.conflict
					end
					internal_count := internal_count.next
				end
			end
		ensure then
			all_values_unique: all_values_unique
			name_and_values_consistent: name_and_values_consistent
		end

feature -- Measurement

	count: INTEGER
		do
			Result := internal_count.code
		end

feature -- Access

	field_name (a_value: N): STRING
		-- exported field name from field value `a_value'
		do
			if attached {HASHABLE} a_value as key and then field_name_by_value.has_key (key) then
				Result := field_name_by_value.found_item
			else
				create Result.make_empty
			end
		ensure
			not_empty: not Result.is_empty
		end

	list: EL_ARRAYED_LIST [N]
		do
			create Result.make (field_table.count)
			across field_table as field loop
				if attached {N} field.item.value (Current) as l_value then
					Result.extend (l_value)
				end
			end
		end

	name (a_value: N): STRING
		-- exported name
		do
			if attached {HASHABLE} a_value as key and then name_by_value.has_key (key) then
				Result := name_by_value.found_item
			else
				create Result.make_empty
			end
		end

	value (a_name: STRING_8): N
		-- enumuration value from `a_name'
		require
			valid_name: is_valid_name (a_name)
			do
			if field_table.has_imported_key (a_name)
				and then attached {N} field_table.found_item.value (Current) as enum_value
			then
				Result := enum_value
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
			Result := name_by_value.count = count
		end

	is_valid_name (a_name: STRING_8): BOOLEAN
		do
			Result := field_table.has_imported (a_name)
		end

	is_valid_value (a_value: N): BOOLEAN
		do
			if attached {HASHABLE} a_value as key then
				Result := name_by_value.has (key)
			end
		end

feature -- Basic operations

	write_crc (crc: EL_CYCLIC_REDUNDANCY_CHECK_32)
		do
			across field_table as field loop
				crc.add_string_8 (field.item.name)
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

feature -- Contract Support

	name_and_values_consistent: BOOLEAN
		-- `True' if all `value' results can be looked up from `name_by_value' items
		do
			Result := across name_by_value as table all
				attached {HASHABLE} value (table.item) as hash_value and then hash_value = table.key
			end
		end

feature {NONE} -- Implementation

	field_included (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			Result := field_type_id.natural_32_code = type_id.to_natural_32
		end

	field_order: like Default_field_order
		-- sorting function to be applied to `{EL_CLASS_DATA}.field_list'
		do
			Result := agent {EL_REFLECTED_FIELD}.name
		end

	new_field_name_by_value: like name_by_value
		do
			create Result.make_equal (field_table.count)
			across field_table as field loop
				if attached {HASHABLE} field.item.value (Current) as key then
					Result.extend (field.item.name, key)
				end
			end
		end

feature {NONE} -- Internal attributes

	field_type_id: CHARACTER_32
		-- using CHARACTER_32 so it won't be included as part of enumeration

	internal_count: CHARACTER_32
		-- using CHARACTER_32 so it won't be included as part of enumeration

	name_by_value: HASH_TABLE [STRING_8, HASHABLE];

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
				[$source AIA_RESPONSE_ENUM]
				[$source AIA_REASON_ENUM]
				[$source EL_CURRENCY_ENUM]
				[$source EL_BOOLEAN_ENUMERATION]*
					[$source PP_ADDRESS_STATUS_ENUM]
				[$source PP_PAYMENT_STATUS_ENUM]
				[$source PP_PAYMENT_PENDING_REASON_ENUM]
				[$source PP_TRANSACTION_TYPE_ENUM]
				[$source TL_PICTURE_TYPE_ENUM]
				[$source EL_IPAPI_CO_JSON_FIELD_ENUM]
				[$source EL_DESCRIPTIVE_ENUMERATION]* [N -> {[$source NUMERIC], [$source HASHABLE]}]
					[$source EROS_ERRORS_ENUM]
				[$source TL_STRING_ENCODING_ENUM]
				[$source TL_MUSICBRAINZ_ENUM]
				[$source EL_HTTP_STATUS_ENUM]
				[$source TL_FRAME_ID_ENUM]
	]"

end -- class EL_ENUMERATION