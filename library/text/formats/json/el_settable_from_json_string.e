note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVELY_SETTABLE] to reflectively set fields
		from corresponding JSON name-value pairs.
	]"
	tests: "Class [$source JSON_PARSING_TEST_SET]"
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
	date: "2021-11-17 18:04:45 GMT (Wednesday 17th November 2021)"
	revision: "24"

deferred class
	EL_SETTABLE_FROM_JSON_STRING

inherit
	EL_SETTABLE_FROM_ZSTRING

	EL_REFLECTION_HANDLER
		undefine
			is_equal
		end

	EL_MODULE_REUSABLE

	EL_MODULE_NAMING

	EL_MODULE_TUPLE

feature {NONE} -- Initialization

	make_from_json (utf_8: STRING)
		do
			make_default
			set_from_json (create {EL_JSON_NAME_VALUE_LIST}.make (utf_8))
		end

feature -- Access

	as_json: ZSTRING
		local
			str: ZSTRING
		do
			across Reuseable.string as reuse loop
				str := reuse.item
				str.append (JSON.open_bracket)
				across field_table as table loop
					if not table.is_first then
						str.append (JSON.comma_new_line)
					end
					str.append (JSON.before_name)
					str.append_string_general (current_reflective.export_name (table.key, False))
					str.append (JSON.after_name)
					if is_field_text (table.item) then
						str.append_character ('"')
						str.append (Escaper.escaped (field_string (table.item), False))
						str.append_character ('"')
					else
						table.item.append_to_string (current_reflective, str)
					end
				end
				str.append (JSON.close_bracket)
				create Result.make_from_other (str)
			end
		end

feature -- Element change

	set_from_json (json_list: EL_JSON_NAME_VALUE_LIST)
		local
			table: like field_table
		do
			table := field_table
			from json_list.start until json_list.after loop
				if table.has_imported (json_list.name_item_8 (False), current_reflective) then
					set_json_field (table.found_item, json_list.value_item (True))
				end
				json_list.forth
			end
		end

feature {NONE} -- Implementation

	set_json_field (field: EL_REFLECTED_FIELD; json_value: ZSTRING)
		do
			field.set_from_string (current_reflective, json_value)
		end

	is_field_text (field: EL_REFLECTED_FIELD): BOOLEAN
		do
			inspect field.category_id
				when {REFLECTOR_CONSTANTS}.Character_8_type, {REFLECTOR_CONSTANTS}.Character_32_type then
					Result := True
			else
				Result := attached {EL_REFLECTED_REFERENCE [ANY]} field
			end
		end

feature {NONE} -- Constants

	Escaper: EL_JSON_VALUE_ESCAPER
		once
			create Result.make
		end

	JSON: TUPLE [open_bracket, close_bracket, before_name, after_name, comma_new_line: ZSTRING]
		once
			create Result
			Tuple.fill_adjusted (Result, "{%N,%N},%T%",%": ,%N", False)
			Result.comma_new_line.insert_character (',', 1)
		end

end