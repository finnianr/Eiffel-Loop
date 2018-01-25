note
	description: "Object with `field_table' attribute of field getter-setter's"
	notes: "[
		When inheriting this class, rename `field_included' as either `is_any_field' or `is_string_or_expanded_field'.

		Override `use_default_values' to return `False' if the default values set
		by `set_default_values' is not required.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-15 12:22:38 GMT (Monday 15th January 2018)"
	revision: "10"

deferred class
	EL_REFLECTIVELY_SETTABLE

inherit
	EL_REFLECTIVE
		redefine
			Except_fields, is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			if not attached field_table then
				field_table := Meta_data_by_type.item (Current).field_table
				if use_default_values then
					set_default_values
				end
			end
		end

feature -- Access

	comma_separated_values: ZSTRING
		--
		local
			table: like field_table; value: READABLE_STRING_GENERAL
			zvalue: ZSTRING; escaped: like Escaped_csv_characters
		do
			table := field_table
			create Result.make (table.count * 5)
			create zvalue.make_empty
			from table.start until table.after loop
				if not Result.is_empty then
					Result.append_character (',')
				end
				value := table.item_for_iteration.to_string (Current)
				if value.has (',') then
					zvalue.wipe_out; zvalue.append_string_general (value)
					if zvalue.has ('"') then
						-- Escape any quotes
						zvalue.replace_substring_general_all (once "%"", once "%"%"")
					end
					zvalue.quote (2)
					Result.append (zvalue)
				else
					Result.append_string_general (value)
				end
				table.forth
			end
			-- Escape '%N', '%R', '\' with \n, \r, \\ respectively
			escaped := Escaped_csv_characters
			from escaped.start until escaped.after loop
				if Result.has_z_code (escaped.item_key.z_code (1)) then
					Result.replace_substring_all (escaped.item_key, escaped.item_value)
				end
				escaped.forth
			end
		end

feature -- Element change

	set_default_values
		local
			table: like field_table
		do
			table := field_table
			from table.start until table.after loop
				table.item_for_iteration.set_default_value (Current)
				table.forth
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
		do
			Result := all_fields_equal (other)
		end

feature {NONE} -- Implementation

	use_default_values: BOOLEAN
		do
			Result := True
		end

feature {EL_REFLECTION_HANDLER} -- Internal attributes

	field_table: EL_REFLECTED_FIELD_TABLE

feature {NONE} -- Constants

	Escaped_csv_characters: EL_ARRAYED_MAP_LIST [ZSTRING, ZSTRING]
		once
			create Result.make (2)
			Result.extend ("\", "\\")
			Result.extend ("%R", "\r")
			Result.extend ("%N", "\n")
		end

	Except_fields: STRING
			-- list of comma-separated fields to be excluded
		once
			Result := "field_table"
		end

end
