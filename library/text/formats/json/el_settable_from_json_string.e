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
	date: "2022-06-20 13:56:49 GMT (Monday 20th June 2022)"
	revision: "27"

deferred class
	EL_SETTABLE_FROM_JSON_STRING

inherit
	EL_REFLECTIVE_I undefine is_equal end

	EL_REFLECTION_HANDLER undefine is_equal end

	EL_MODULE_REUSEABLE

	EL_MODULE_NAMING

	EL_JSON_CONSTANTS

feature {NONE} -- Initialization

	make_from_json (utf_8: STRING)
		do
			make_default
			set_from_json (utf_8)
		end

	make_default
		deferred
		end

feature -- Access

	as_json: ZSTRING
		local
			str, value: ZSTRING
		do
			across Reuseable.string_pool as pool loop
				str := pool.borrowed_item; value := pool.borrowed_item
				str.append (JSON.open_bracket)
				across field_table as table loop
					if not table.is_first then
						str.append (JSON.comma_new_line)
					end
					str.append (JSON.before_name)
					str.append_string_general (table.item.export_name)
					str.append (JSON.after_name)
					if is_field_text (table.item) then
						value.wipe_out
						table.item.append_to_string (current_reflective, value)
						value.escape (Escaper)

						str.append_character ('"') ;str.append (value);  str.append_character ('"')
					else
						table.item.append_to_string (current_reflective, str)
					end
				end
				str.append (JSON.close_bracket)
				create Result.make_from_other (str)
			end
		end

feature -- Element change

	set_from_json (utf_8_json: STRING)
		do
			across Reuseable.string_8 as reuse_8 loop
				across Reuseable.string as reuse loop
					internal_set_from_json (utf_8_json, reuse_8.item, reuse.item)
				end
			end
		end

	set_from_json_list (json_list: EL_JSON_NAME_VALUE_LIST)
		do
			if attached field_table as table then
				from json_list.start until json_list.after loop
					if table.has_imported_key (json_list.name_item_8 (False)) then
						table.found_item.set_from_string (current_reflective, json_list.value_item (True))
					end
					json_list.forth
				end
			end
		end

feature {NONE} -- Implementation

	internal_set_from_json (utf_8_json, utf_8_value: STRING; value: ZSTRING)
		-- random access setting of object field corresponding to JSON field
		local
			quoted_name: STRING; name_index, start_index, end_index, right_index: INTEGER;
			s: EL_STRING_8_ROUTINES
		do
			across field_table as table loop
--				Search JSON text for each exported field name in quotes
				quoted_name := Name_buffer.quoted (table.item.export_name, '"')
				name_index := utf_8_json.substring_index (quoted_name, 1)
				if name_index > 0 then
					right_index := name_index + quoted_name.count
					start_index := utf_8_json.index_of (':', right_index)
--					if there is a colon within 2 characters to the right of field name
					if start_index >= right_index and start_index <= right_index + 1 then
						start_index := start_index + 1
						end_index := utf_8_json.index_of ('%N', start_index)
						if end_index = 0 then
							end_index := utf_8_json.count
						end
						utf_8_value.wipe_out; utf_8_value.append_substring (utf_8_json, start_index, end_index)
						utf_8_value.adjust; utf_8_value.prune_all_trailing (',')
						s.remove_double_quote (utf_8_value)

						if not utf_8_value.has ('\') and then s.is_ascii (utf_8_value) then
							if attached {EL_REFLECTED_STRING_8} table.item as str_8_field then
								str_8_field.set (current_reflective, utf_8_value.twin)
							else
								table.item.set_from_string (current_reflective, utf_8_value)
							end
						else
--							Has either a JSON escape sequence or UTF-8 sequence
							value.wipe_out; value.append_utf_8 (utf_8_value)
							value.unescape (Unescaper)
							table.item.set_from_string (current_reflective, value)
						end
					end
				end
			end
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

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

end