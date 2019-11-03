note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVELY_SETTABLE] to reflectively set fields
		from corresponding JSON name-value pairs.
	]"
	tests: "Class [$source REFLECTIVE_TEST_SET]"
	descendants: "[
		The following example implementations are from the Amazon Instant Access API for Eiffel.

			EL_SETTABLE_FROM_JSON_STRING*
				[$source AIA_RESPONSE]
					[$source AIA_PURCHASE_RESPONSE]
						[$source AIA_REVOKE_RESPONSE]
					[$source AIA_GET_USER_ID_RESPONSE]
				[$source AIA_REQUEST]*
					[$source AIA_GET_USER_ID_REQUEST]
					[$source AIA_PURCHASE_REQUEST]
						[$source AIA_REVOKE_REQUEST]
				[$source JSON_CURRENCY]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 13:17:07 GMT (Friday 4th October 2019)"
	revision: "16"

deferred class
	EL_SETTABLE_FROM_JSON_STRING

inherit
	EL_SETTABLE_FROM_ZSTRING

	EL_REFLECTION_HANDLER
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS

	EL_MODULE_NAMING

	EL_SHARED_ONCE_ZSTRING

feature {NONE} -- Initialization

	make_from_json (utf_8: STRING)
		do
			make_default
			set_from_json (create {EL_JSON_NAME_VALUE_LIST}.make (utf_8))
		end

feature -- Access

	as_json: ZSTRING
		local
			table: like field_table; is_first: BOOLEAN
			field: TUPLE [name: STRING; value: ZSTRING]
		do
			field := [create {STRING}.make (0), Empty_string]

			Result := once_copy_general (once "{%N")
			table := field_table
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
				if table.has_name (json_list.name_item_8, current_reflective) then
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
