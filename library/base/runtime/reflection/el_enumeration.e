note
	description: "[
		Object for mapping names to code numbers with bi-directional lookups, i.e.
		obtain the code from a name and the name from a code. The generic parameter 
		can be any [https://www.eiffel.org/files/doc/static/18.01/libraries/base/numeric_chart.html NUMERIC] type.
	]"
	instructions: "[
		Typically you would make a shared instance of an implementation class inheriting
		this class.

		Overriding import_name from [$source EL_REFLECTIVELY_SETTABLE] allows you to lookup
		a code using a foreign naming convention, camelCase, for example. Overriding
		export_name allows the name returned by `code_name' to use a foreign convention.
		Choose a convention from the Naming object.
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
	date: "2018-04-29 8:21:06 GMT (Sunday 29th April 2018)"
	revision: "12"

deferred class
	EL_ENUMERATION [N -> {NUMERIC, HASHABLE}]

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make
		redefine
			make, field_included, initialize_fields
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make
		do
			field_type_id := ({N}).type_id
			Precursor
			create name_by_value.make (field_table.count)
			create value_by_name.make_equal (field_table.count)
			initialize_fields
			across
				field_table as field
			loop
				extend_field_tables (field.key, field.item)
			end
		end

	initialize_fields
			-- initialize fields with unique value
		do
			across
				field_table as field
			loop
				field.item.set_from_integer (Current, field.cursor_index)
			end
		end

feature -- Access

	value (a_name: STRING_8): N
		local
			table: like value_by_name
		do
			table := value_by_name
			table.search (import_name (a_name, False))
			if table.found then
				Result := table.found_item
			end
		end

	name (a_value: N): STRING_8
		local
			table: like name_by_value
		do
			table := name_by_value
			table.search (a_value)
			if table.found then
				Result := export_name (table.found_item, True)
			else
				create Result.make_empty
			end
		end

	list: EL_ARRAYED_LIST [N]
		do
			create Result.make_from_array (name_by_value.current_keys)
		end

feature -- Status query

	has_duplicate_value: BOOLEAN

	is_valid_value (a_value: N): BOOLEAN
		do
			Result := name_by_value.has_key (a_value)
		end

	is_valid_name (a_name: STRING_8): BOOLEAN
		do
			Result := value_by_name.has_key (a_name)
		end

feature {NONE} -- Implementation

	extend_field_tables (a_name: STRING_8; field: EL_REFLECTED_FIELD)
		do
			if attached {N} field.value (Current) as l_value then
				name_by_value.put (a_name, l_value)
				value_by_name.extend (l_value, a_name)
			end
			has_duplicate_value := has_duplicate_value or name_by_value.conflict
		end

	field_included (object: like current_object; i: INTEGER_32): BOOLEAN
		do
			Result := field_type_id = object.field_static_type (i)
		end

feature {NONE} -- Internal attributes

	field_type_id: INTEGER_32

	value_by_name: HASH_TABLE [N, STRING_8]

	name_by_value: HASH_TABLE [STRING_8, N]

invariant
	no_duplicate_values: not has_duplicate_value

note
	descendants: "[
			EL_ENUMERATION*
				[$source EL_CURRENCY_ENUM]
				[$source PP_PAYMENT_STATUS_ENUM]
				[$source PP_TRANSACTION_TYPE_ENUM]
				[$source PP_PAYMENT_PENDING_REASON_ENUM]
				[$source EL_HTTP_STATUS_ENUM]
				[$source PP_L_VARIABLE_ENUM]
	]"
end -- class EL_ENUMERATION

