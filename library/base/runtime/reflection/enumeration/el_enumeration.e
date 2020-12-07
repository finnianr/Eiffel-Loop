note
	description: "[
		Object for mapping names to code numbers with bi-directional lookups, i.e.
		obtain the code from a name and the name from a code. The generic parameter 
		can be any [https://www.eiffel.org/files/doc/static/18.01/libraries/base/numeric_chart.html NUMERIC] type.
	]"
	instructions: "[
		Typically you would make a shared instance of an implementation class inheriting
		this class.

		Overriding `import_name' from [$source EL_REFLECTIVELY_SETTABLE] allows you to lookup
		a code using a foreign naming convention, camelCase, for example. Overriding
		`export_name' allows the name returned by `code_name' to use a foreign convention.
		Choose a convention from the `Naming' object.
	]"
	notes: "[
		**TO DO**
		
		A problem that needs solving is how to guard against accidental changes in
		auto-generated code values that are used persistently. One idea is to use a contract
		comparing a CRC checksum based on an alphabetical ordering to a hard coded value.
		
		Also there needs to be a mechanism to allow "late-editions" that will not disturb
		existing assignments.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-12-07 10:25:36 GMT (Monday 7th December 2020)"
	revision: "35"

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
			make, initialize_fields
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
					name_by_value.put (export_name (field.key, True), key)
					check
						no_conflict: not name_by_value.conflict
					end
					internal_count := internal_count.next
				end
			end
		ensure then
			all_values_unique: all_values_unique
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
			if field_table.has_key (import_name (a_name, False))
				and then attached {N} field_table.found_item.value (Current) as enum_value
			then
				Result := enum_value
			else
				check
					value_found: False
				end
			end
		end

feature -- Status query

	all_values_unique: BOOLEAN
		-- `True' if each enumeration field is asssigned a unique value
		do
			Result := name_by_value.count = count
		end

	is_valid_name (a_name: STRING_8): BOOLEAN
		do
			Result := field_table.has (import_name (a_name, False))
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

feature {NONE} -- Implementation

	field_included (basic_type, type_id: INTEGER_32): BOOLEAN
		do
			Result := field_type_id.natural_32_code = type_id.to_natural_32
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
	descendants: "[
			EL_ENUMERATION*
				[$source EL_CURRENCY_ENUM]
				[$source FCGI_RECORD_TYPE_ENUM]
				[$source PP_PAYMENT_STATUS_ENUM]
				[$source PP_TRANSACTION_TYPE_ENUM]
				[$source PP_PAYMENT_PENDING_REASON_ENUM]
				[$source EL_HTTP_STATUS_ENUM]
				[$source PP_L_VARIABLE_ENUM]
	]"

end -- class EL_ENUMERATION