note
	description: "[
		Used in conjunction with `[$source EL_REFLECTIVELY_SETTABLE]' to reflectively set fields
		from corresponding JSON name-value pairs.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 12:00:25 GMT (Tuesday 24th April 2018)"
	revision: "7"

deferred class
	EL_SETTABLE_FROM_JSON_STRING

inherit
	EL_SETTABLE_FROM_ZSTRING

	EL_STRING_CONSTANTS
		undefine
			is_equal
		end

	EL_SHARED_ONCE_STRINGS
		undefine
			is_equal
		end

	EL_MODULE_NAMING
		undefine
			is_equal
		end

	EL_REFLECTION_HANDLER
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_from_json (string: STRING)
		do
			make_default
			set_from_json (create {EL_JSON_NAME_VALUE_LIST}.make (string))
		end

feature -- Access

	as_json: ZSTRING
		local
			table: like field_table; is_first: BOOLEAN
			field: TUPLE [name: STRING; value: ZSTRING]
		do
			field := [create {STRING}.make (0), Empty_string]

			Result := empty_once_string
			table := field_table
			Result.append_string_general (once "{%N")
			from is_first := True; table.start until table.after loop
				if is_first then
					is_first := False
				else
					Result.append_string_general (once ",%N")
				end
				field.name := current_reflective.export_name (table.key_for_iteration, False)
				field.value := Escaper.escaped (field_string (table.item_for_iteration), False)
				Result.append (Field_template #$ field)
				table.forth
			end
			Result.append_string_general (once "%N}")
			Result := Result.twin
		end

feature -- Element change

	set_from_json (json_list: EL_JSON_NAME_VALUE_LIST)
		local
			table: like field_table
		do
			table := field_table
			from json_list.start until json_list.after loop
				table.search (json_list.name_item_8, current_reflective)
				if table.found then
					table.found_item.set_from_string (current_reflective, json_list.value_item)
				end
				json_list.forth
			end
		end

feature {NONE} -- Constants

	Export_tuple: TUPLE [name_in, name_out: STRING]
		once
			Result := ["", ""]
		end

	Escaper: EL_JSON_VALUE_ESCAPER
		once
			create Result.make
		end

	Field_separator: ZSTRING
		once
			Result := ",%N"
		end

	Field_template: ZSTRING
		once
			Result := "[
				"#": "#"
			]"
			Result.prepend_character ('%T')
		end

end
