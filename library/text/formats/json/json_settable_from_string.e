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
	date: "2023-11-16 14:40:24 GMT (Thursday 16th November 2023)"
	revision: "38"

deferred class
	JSON_SETTABLE_FROM_STRING

inherit
	EL_REFLECTIVE_I

	EL_REFLECTION_HANDLER

	EL_MODULE_NAMING

	JSON_CONSTANTS

	EL_SHARED_STRING_8_CURSOR; EL_SHARED_ZSTRING_BUFFER_SCOPES

feature {NONE} -- Initialization

	make_from_json (utf_8: READABLE_STRING_8)
		do
			make_default
			set_from_json (utf_8)
		end

	make_from_json_list (json_list: JSON_NAME_VALUE_LIST)
		do
			make_default
			set_from_json_list (json_list)
		end

	make_default
		deferred
		end

feature -- Access

	as_json: ZSTRING
		local
			str, value: ZSTRING
		do
			across String_pool_scope as pool loop
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

	set_from_json (utf_8_json: READABLE_STRING_8)
		-- random access setting of object field corresponding to JSON field
		do
			set_from_json_list (create {JSON_NAME_VALUE_LIST}.make (utf_8_json))
		end

	set_from_json_list (json_list: JSON_NAME_VALUE_LIST)
		do
			if attached field_table as table then
				from json_list.start until json_list.after loop
					if table.has_imported_key (json_list.item_name (False))
						and then attached table.found_item as field
						and then attached json_list.item_value_utf_8 (False) as utf_8_value
					then
						if not utf_8_value.has ('\') and then cursor_8 (utf_8_value).all_ascii then
							if attached {EL_REFLECTED_STRING_8} field as str_8_field then
								str_8_field.set (current_reflective, utf_8_value.twin)
							else
								field.set_from_string (current_reflective, utf_8_value)
							end
						else
							field.set_from_string (current_reflective, json_list.item_value (False))
						end
					end
					json_list.forth
				end
			end
		end

feature {NONE} -- Implementation

	is_field_text (field: EL_REFLECTED_FIELD): BOOLEAN
		do
			inspect field.abstract_type
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