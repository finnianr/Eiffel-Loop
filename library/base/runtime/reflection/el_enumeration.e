note
	description: "[
		Object for mapping names to code numbers with bi-directional lookups, i.e.
		obtain the code from a name and the name from a code. The generic parameter 
		can be any `NUMERIC' type.
	]"
	instructions: "[
		Typically you would make a shared instance of an implementation class inheriting
		this class.

		Overriding import_name from `EL_REFLECTIVELY_SETTABLE' allows you to lookup
		a code using a foreign naming convention, camelCase, for example. Overriding
		export_name allows the name returned by `code_name' to use a foreign convention.
		Choose a convention from the Naming object.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-22 12:04:38 GMT (Monday 22nd January 2018)"
	revision: "8"

deferred class
	EL_ENUMERATION [N -> {NUMERIC, HASHABLE}]

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make
		redefine
			make, field_included, set_default_values
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
			set_default_values
			across
				field_table as field
			loop
				extend_field_tables (field.key, field.item)
			end
		end

	set_default_values
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
			l_name: STRING_8
			table: like value_by_name
		do
			l_name := String_8_pool.new_string
			table := value_by_name
			import_name (a_name, l_name)
			table.search (l_name)
			if table.found then
				Result := table.found_item
			end
			String_8_pool.recycle (l_name)
		end

	name (a_value: N): STRING_8
		local
			l_name: STRING_8
			table: like name_by_value
		do
			table := name_by_value
			table.search (a_value)
			if table.found then
				l_name := table.found_item
				create Result.make (l_name.count)
				export_name (l_name, Result)
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

end -- class EL_ENUMERATION

