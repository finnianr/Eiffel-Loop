note
	description: "[
		Used in conjunction with `[$source EL_REFLECTIVELY_SETTABLE]' to reflectively set fields
		from name-value pairs, where value conforms to `READABLE_STRING_GENERAL'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-29 11:05:18 GMT (Thursday 29th March 2018)"
	revision: "8"

deferred class
	EL_SETTABLE_FROM_STRING

inherit
	STRING_HANDLER
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		deferred
		end

	make_from_table (field_values: HASH_TABLE [like new_string, STRING])
		do
			make_default
			set_from_table (field_values)
		end

	make_from_zkey_table (field_values: HASH_TABLE [like new_string, ZSTRING])
		-- make from table with keys of type `ZSTRING'
		do
			make_default
			set_from_zkey_table (field_values)
		end

feature -- Access

	field_item (name: READABLE_STRING_GENERAL): like new_string
		local
			table: like field_table
		do
			table := field_table
			table.search (name)
			if table.found then
				Result := field_string (table.found_item)
			else
				Result := new_string
			end
		end

feature -- Element change

	set_field (name: READABLE_STRING_GENERAL; value: like new_string)
		local
			table: like field_table
		do
			table := field_table
			table.search (name)
			if table.found then
				table.found_item.set_from_string (current_reflective, value)
			end
		end

	set_field_from_nvp (nvp: like new_string; delimiter: CHARACTER_32)
		-- Set field from name-value pair `nvp' delimited by `delimiter'. For eg. "var=value" or "var: value"
		require
			has_one_equal_sign: nvp.has (delimiter)
		local
			pair: like Name_value_pair
		do
			pair := Name_value_pair
			pair.set_from_string (nvp, delimiter)
			set_field (pair.name, pair.value)
		end

	set_from_table (field_values: HASH_TABLE [like new_string, STRING])
		do
			from field_values.start until field_values.after loop
				set_field (field_values.key_for_iteration, field_values.item_for_iteration)
				field_values.forth
			end
		end

	set_from_zkey_table (field_values: HASH_TABLE [like new_string, ZSTRING])
		-- set from table with keys of type `ZSTRING'
		local
			name: STRING
		do
			create name.make (20)
			from field_values.start until field_values.after loop
				name.wipe_out
				field_values.key_for_iteration.append_to_string_8 (name)
				set_field (name, field_values.item_for_iteration)
				field_values.forth
			end
		end

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	field_string (a_field: EL_REFLECTED_FIELD): STRING_GENERAL
		deferred
		end

	field_table: EL_REFLECTED_FIELD_TABLE
		deferred
		end

	name_value_pair: EL_NAME_VALUE_PAIR [STRING_GENERAL]
		deferred
		end

	new_string: STRING_GENERAL
		deferred
		end

feature {EL_REFLECTION_HANDLER} -- Implementation

	string_type_id: INTEGER
		-- type_id of string {S}
		deferred
		end

end
