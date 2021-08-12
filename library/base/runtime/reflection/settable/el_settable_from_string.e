note
	description: "[
		Used in conjunction with [$source EL_REFLECTIVELY_SETTABLE] to reflectively set fields
		from name-value pairs, where value conforms to [$source READABLE_STRING_GENERAL].
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-12 13:48:17 GMT (Thursday 12th August 2021)"
	revision: "20"

deferred class
	EL_SETTABLE_FROM_STRING

inherit
	STRING_HANDLER
		undefine
			is_equal
		end

	EL_REFLECTION_HANDLER
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		deferred
		end

	make_from_converted_map_list (
		map_list: EL_ARRAYED_MAP_LIST [STRING, like new_string]; converted: FUNCTION [like new_string, ANY]
	)
		do
			make_default
			set_from_converted_map_list (map_list, converted)
		end

	make_from_map_list (map_list: EL_ARRAYED_MAP_LIST [STRING, like new_string])
		do
			make_default
			set_from_map_list (map_list)
		end

	make_from_table (field_values: like to_table)
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
			if table.has_imported (name, current_reflective) then
				Result := field_string (table.found_item)
			else
				Result := new_string
			end
		end

	to_table: HASH_TABLE [like new_string, STRING]
		local
			table: like field_table; value: like new_string
		do
			table := field_table
			create Result.make_equal (table.count)
			Result.compare_objects
			from table.start until table.after loop
				value := new_string
				value.append (table.item_for_iteration.to_string (current_reflective))
				Result.extend (value, table.key_for_iteration)
				table.forth
			end
		end

	to_zkey_table: HASH_TABLE [like new_string, ZSTRING]
		local
			table: like field_table; value: like new_string
		do
			table := field_table
			create Result.make_equal (table.count)
			Result.compare_objects
			from table.start until table.after loop
				value := new_string
				value.append (table.item_for_iteration.to_string (current_reflective))
				Result.extend (value, table.key_for_iteration)
				table.forth
			end
		end

feature -- Element change

	set_field (name: READABLE_STRING_GENERAL; value: like new_string)
		do
			set_table_field (field_table, name, value)
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

	set_from_converted_map_list (
		map_list: EL_ARRAYED_MAP_LIST [STRING, like new_string]; converted: FUNCTION [like new_string, ANY]
	)
		-- set reference fields with `converted' value of `map_list' value strings
		require
			valid_converted_map_list: valid_converted_map_list (map_list, converted)
		local
			table: like field_table; tuple: TUPLE [like new_string]
		do
			table := field_table
			create tuple
			from map_list.start until map_list.after loop
				tuple.put (map_list.item_value, 1)
				set_table_field (table, map_list.item_key, converted.item (tuple))
				map_list.forth
			end
		end

	set_from_lines (lines: LINEAR [like new_string]; delimiter: CHARACTER_32; is_comment: PREDICATE [like new_string])
			-- set fields from `lines' formatted as `<name>: <value>'
			-- but ignoring lines where `is_comment (lines.item)' is True
		local
			line: like new_string
		do
			from lines.start until lines.after loop
				line := lines.item
				if not is_comment (line) and then line.has (delimiter) then
					set_field_from_nvp (line, delimiter)
				end
				lines.forth
			end
		end

	set_from_map_list (map_list: EL_ARRAYED_MAP_LIST [STRING, like new_string])
		local
			table: like field_table
		do
			table := field_table
			from map_list.start until map_list.after loop
				set_table_field (table, map_list.item_key, map_list.item_value)
				map_list.forth
			end
		end

	set_from_table (field_values: like to_table)
		local
			table: like field_table
		do
			table := field_table
			from field_values.start until field_values.after loop
				set_table_field (table, field_values.key_for_iteration, field_values.item_for_iteration)
				field_values.forth
			end
		end

	set_from_zkey_table (field_values: HASH_TABLE [like new_string, ZSTRING])
		-- set from table with keys of type `ZSTRING'
		local
			table: like field_table; name: STRING
		do
			table := field_table
			create name.make (20)
			from field_values.start until field_values.after loop
				name.wipe_out
				field_values.key_for_iteration.append_to_string_8 (name)
				set_table_field (table, name, field_values.item_for_iteration)
				field_values.forth
			end
		end

feature -- Contract Support

	valid_converted_map_list (
		map_list: EL_ARRAYED_MAP_LIST [STRING, like new_string]; converted: FUNCTION [like new_string, ANY]
	): BOOLEAN
		local
			converted_type: INTEGER; table: like field_table; tuple: TUPLE [like new_string]
		do
			table := field_table
			if not map_list.is_empty then
				create tuple
				tuple.put (map_list.first_value, 1)
				converted_type := converted.item (tuple).generating_type.type_id
				Result := True
				from map_list.start until not Result or map_list.after loop
					if table.has_imported (map_list.item_key, current_reflective) then
						Result := table.found_item.type_id = converted_type
					end
					map_list.forth
				end
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

	meta_data: EL_CLASS_META_DATA
		deferred
		end

	name_value_pair: EL_NAME_VALUE_PAIR [STRING_GENERAL]
		deferred
		end

	new_string: STRING_GENERAL
		deferred
		end

feature {EL_REFLECTION_HANDLER} -- Implementation

	set_inner_table_field (table: like field_table; name: READABLE_STRING_GENERAL; object: EL_REFLECTIVE; value: ANY)
		local
			pos_dot: INTEGER
		do
			pos_dot := name.index_of ('.', 1)
			if pos_dot > 0 then
				if attached Name_part_pool.new_scope as pool and then attached pool.reuse_item as name_part then
					name_part.append_substring_general (name, 1, pos_dot - 1)
					if table.has_imported (name_part, object)
						and then attached {EL_REFLECTIVE} table.found_item.value (object) as inner_object
					then
						name_part.wipe_out
						name_part.append_substring_general (name, pos_dot + 1, name.count)
						-- Recurse until no more dots in name
						set_inner_table_field (inner_object.field_table, name_part, inner_object, value)
					end
					pool.recycle_end (name_part)
				end

			elseif table.has_imported (name, object) then
				set_reflected_field (table.found_item, object, value)
			end
		end

	set_table_field (table: like field_table; name: READABLE_STRING_GENERAL; value: ANY)
		do
			if name.has ('.') then
				set_inner_table_field (table, name, current_reflective, value)
			elseif table.has_imported (name, current_reflective) then
				set_reflected_field (table.found_item, current_reflective, value)
			end
		end

	set_reflected_field (field: EL_REFLECTED_FIELD; object: EL_REFLECTIVE; value: ANY)
		do
			if attached {like new_string} value as string then
				field.set_from_string (object, string)
			else
				field.set (object, value)
			end
		end

feature {NONE} -- Constants

	Name_part_pool: EL_STRING_POOL [ZSTRING]
		once
			create Result.make
		end

note
	descendants: "[
			EL_SETTABLE_FROM_STRING*
				[$source EL_SETTABLE_FROM_STRING_32]*
					[$source MY_DRY_CLASS]
				[$source EL_SETTABLE_FROM_STRING_8]*
					[$source AIA_CREDENTIAL_ID]
					[$source AIA_AUTHORIZATION_HEADER]
					[$source EL_REFLECTIVE_RSA_KEY]*
						[$source EL_RSA_PRIVATE_KEY]
				[$source EL_SETTABLE_FROM_ZSTRING]*
					[$source FCGI_REQUEST_PARAMETERS]
					[$source COUNTRY]
						[$source CAMEL_CASE_COUNTRY]
						[$source STORABLE_COUNTRY]
					[$source PP_TRANSACTION]
					[$source JOB]
					[$source EL_SETTABLE_FROM_JSON_STRING]*
						[$source AIA_RESPONSE]
							[$source AIA_PURCHASE_RESPONSE]
								[$source AIA_REVOKE_RESPONSE]
							[$source AIA_GET_USER_ID_RESPONSE]
							[$source AIA_FAIL_RESPONSE]
						[$source JSON_CURRENCY]
						[$source PERSON]
						[$source AIA_REQUEST]*
							[$source AIA_GET_USER_ID_REQUEST]
							[$source AIA_PURCHASE_REQUEST]
								[$source AIA_REVOKE_REQUEST]
					[$source FCGI_HTTP_HEADERS]
					[$source EL_COMMA_SEPARATED_WORDS]
	]"
end