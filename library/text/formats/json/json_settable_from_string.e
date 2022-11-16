note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVELY_SETTABLE] to reflectively set fields
		from corresponding JSON name-value pairs.
	]"
	tests: "[
			[$source JSON_PARSING_TEST_SET]
			[$source HTTP_CONNECTION_TEST_SET]
			[$source HASH_TABLE_TEST_SET]
			[$source AMAZON_INSTANT_ACCESS_TEST_SET]
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "32"

deferred class
	JSON_SETTABLE_FROM_STRING

inherit
	EL_REFLECTIVE_I undefine is_equal end

	EL_REFLECTION_HANDLER undefine is_equal end

	EL_MODULE_REUSEABLE

	EL_MODULE_NAMING

	JSON_CONSTANTS

	EL_SHARED_STRING_8_CURSOR

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
		-- random access setting of object field corresponding to JSON field
		local
			utf_8_value: STRING; field_intervals: JSON_FIELD_NAME_INTERVALS
			value: ZSTRING
		do
			create field_intervals.make (utf_8_json)
			across Reuseable.string as reuse loop
				value := reuse.item
				across field_table as table loop
					field_intervals.find_field (table.item.export_name)

					if field_intervals.found then
						utf_8_value := field_intervals.item_utf_8_value
						if not utf_8_value.has ('\') and then cursor_8 (utf_8_value).all_ascii then
							if attached {EL_REFLECTED_STRING_8} table.item as str_8_field then
								str_8_field.set (current_reflective, utf_8_value.twin)
							else
								table.item.set_from_string (current_reflective, utf_8_value)
							end
						else
	--						Has either a JSON escape sequence or UTF-8 sequence
							value.wipe_out; value.append_utf_8 (utf_8_value)
							value.unescape (Unescaper)
							table.item.set_from_string (current_reflective, value)
						end
					end
				end
			end
		end

	set_from_json_list (json_list: JSON_NAME_VALUE_LIST)
		do
			if attached field_table as table then
				from json_list.start until json_list.after loop
					if table.has_imported_key (json_list.name_item (False)) then
						table.found_item.set_from_string (current_reflective, json_list.value_item (True))
					end
					json_list.forth
				end
			end
		end

feature {NONE} -- Implementation

	is_field_text (field: EL_REFLECTED_FIELD): BOOLEAN
		do
			inspect field.category_id
				when {REFLECTOR_CONSTANTS}.Character_8_type, {REFLECTOR_CONSTANTS}.Character_32_type then
					Result := True
			else
				Result := attached {EL_REFLECTED_REFERENCE [ANY]} field
			end
		end

	new_field_index (utf_8_json: STRING): EL_ARRAYED_LIST [INTEGER]
		-- index table of character to right of first quote-mark for each line
		local
			splitter: EL_SPLIT_ON_CHARACTER [STRING]; i: INTEGER; found: BOOLEAN
		do
			create Result.make (utf_8_json.occurrences ('%N') + 1)
			create splitter.make (utf_8_json, '%N')
			across splitter as split loop
				found := False
				from i := split.item_lower until found or else i > split.item_upper loop
					if utf_8_json [i] = '"' then
						found := True
					else
						i := i + 1
					end
				end
				if found and i + 1 <= split.item_upper then
					Result.extend (i + 1)
				end
			end
		end

note
	descendants: "[
			EL_SETTABLE_FROM_JSON_STRING*
				[$source PERSON]
				[$source AIA_RESPONSE]
					[$source AIA_FAIL_RESPONSE]
					[$source AIA_PURCHASE_RESPONSE]
						[$source AIA_REVOKE_RESPONSE]
					[$source AIA_GET_USER_ID_RESPONSE]
				[$source JSON_CURRENCY]
				[$source AIA_REQUEST]*
					[$source AIA_PURCHASE_REQUEST]
						[$source AIA_REVOKE_REQUEST]
					[$source AIA_GET_USER_ID_REQUEST]
				[$source EL_IP_ADDRESS_GEOLOCATION]
					[$source EL_IP_ADDRESS_GEOGRAPHIC_INFO]
	]"

end