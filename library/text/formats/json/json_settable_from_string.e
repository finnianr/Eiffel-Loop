note
	description: "[
		Used in conjunction with ${EL_REFLECTIVELY_SETTABLE} to reflectively set fields
		from corresponding JSON name-value pairs.
	]"
	tests: "[
			${JSON_PARSING_TEST_SET}
			${HTTP_CONNECTION_TEST_SET}
			${HASH_TABLE_TEST_SET}
			${AMAZON_INSTANT_ACCESS_TEST_SET}
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 9:27:17 GMT (Tuesday 29th April 2025)"
	revision: "43"

deferred class
	JSON_SETTABLE_FROM_STRING

inherit
	EL_REFLECTIVE_I

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_NAMING

	JSON_CONSTANTS

	EL_SHARED_ZSTRING_BUFFER_POOL

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
			if attached String_pool as pool and then attached pool.biggest_item as big_borrowed
				and then attached pool.borrowed_item as borrowed
			then
				str := big_borrowed.empty; value := borrowed.empty
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

				big_borrowed.return; borrowed.return
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
			if attached field_export_table as table then
				from json_list.start until json_list.after loop
					if table.has_key (json_list.item_name (False))
						and then attached table.found_item as field
						and then attached json_list.item_value_utf_8 (False) as utf_8_value
					then
						if not utf_8_value.has ('\') and then super_8 (utf_8_value).is_ascii then
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
			splitter: EL_SPLIT_ON_CHARACTER_8 [STRING]; i: INTEGER; found: BOOLEAN
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
				${PERSON}
				${AIA_RESPONSE}
					${AIA_FAIL_RESPONSE}
					${AIA_PURCHASE_RESPONSE}
						${AIA_REVOKE_RESPONSE}
					${AIA_GET_USER_ID_RESPONSE}
				${JSON_CURRENCY}
				${AIA_REQUEST}*
					${AIA_PURCHASE_REQUEST}
						${AIA_REVOKE_REQUEST}
					${AIA_GET_USER_ID_REQUEST}
				${EL_IP_ADDRESS_GEOLOCATION}
					${EL_IP_ADDRESS_GEOGRAPHIC_INFO}
	]"

end