note
	description: "[
		Used in conjunction with ${EL_REFLECTIVELY_SETTABLE} to reflectively set fields
		from name-value pairs, where value conforms to ${READABLE_STRING_GENERAL}.
	]"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-24 13:48:30 GMT (Saturday 24th August 2024)"
	revision: "33"

deferred class
	EL_SETTABLE_FROM_STRING

inherit
	STRING_HANDLER
		undefine
			is_equal
		end

	EL_REFLECTION_HANDLER

	EL_SHARED_CLASS_ID; EL_SHARED_IMMUTABLE_8_MANAGER

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

	make_from_table (value_table: like to_table)
		do
			make_default
			set_from_table (value_table)
		end

	make_from_zkey_table (value_table: HASH_TABLE [like new_string, ZSTRING])
		-- make from table with keys of type `ZSTRING'
		do
			make_default
			set_from_zkey_table (value_table)
		end

feature -- Access

	field_item (name: READABLE_STRING_GENERAL): like new_string
		local
			table: like field_table
		do
			table := field_table
			if table.has_imported_key (name) then
				Result := field_string (table.found_item)
			else
				Result := new_string
			end
		end

	to_table: HASH_TABLE [like new_string, IMMUTABLE_STRING_8]
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

	set_field (a_name: READABLE_STRING_GENERAL; value: like new_string)
		do
			inspect Class_id.string_storage_type (a_name)
				when '1' then
					if attached {READABLE_STRING_8} a_name as name then
						set_table_field (field_table, name, value)
					end
				when 'X' then
					if attached {ZSTRING} a_name as name then
						set_table_field (field_table, name.to_shared_immutable_8, value)
					end
			else
				set_table_field (field_table, Name_buffer.copied_general (a_name), value)
			end
		end

	set_field_from_line (line: like new_string; delimiter: CHARACTER_32)
		-- if `line' has `delimiter' set named field from name-value pair `nvp' delimited by `delimiter'.
		-- For eg. "var=value" or "var: value"
		do
			if line.has (delimiter) then
				set_field_from_nvp (line, delimiter)
			end
		end

	set_field_from_nvp (nvp_line: like new_string; delimiter: CHARACTER_32)
		-- set field from name-value pair `nvp_line' delimited by `delimiter' if name is Eiffel code identifier
		-- For eg. "var=value" or "var: value"
		require
			has_delimiter: nvp_line.has (delimiter)
		do
			if attached name_value_pair as pair then
				pair.set_from_string (nvp_line, delimiter)
				if is_ascii_identifier (pair.name) then
					set_field (pair.name, pair.value)
				end
			end
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

	set_from_lines (lines: CONTAINER [like new_string]; delimiter: CHARACTER_32)
		-- set fields from `lines' formatted as `<name>: <value>'
		do
			if attached {ITERABLE [like new_string]} lines as iterable_lines then
				across iterable_lines as line loop
					set_field_from_line (line.item, delimiter)
				end

			elseif attached {LINEAR [like new_string]} lines.linear_representation as list then
				from list.start until list.after loop
					set_field_from_line (list.item, delimiter)
					list.forth
				end
			end
		end

	set_from_map_list (map_list: EL_ARRAYED_MAP_LIST [STRING, like new_string])
		do
			if attached field_table as table then
				from map_list.start until map_list.after loop
					set_table_field (table, map_list.item_key, map_list.item_value)
					map_list.forth
				end
			end
		end

	set_from_table (value_table: like to_table)
		do
			if attached field_table as table then
				from value_table.start until value_table.after loop
					set_table_field (table, value_table.key_for_iteration, value_table.item_for_iteration)
					value_table.forth
				end
			end
		end

	set_from_zkey_table (value_table: HASH_TABLE [like new_string, ZSTRING])
		-- set from table with keys of type `ZSTRING'
		do
			if attached field_table as table then
				from value_table.start until value_table.after loop
					if attached value_table.key_for_iteration.to_shared_immutable_8 as key then
						set_table_field (table, key, value_table.item_for_iteration)
					end
					value_table.forth
				end
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
					if table.has_imported_key (map_list.item_key) then
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

	field_table: EL_FIELD_TABLE
		deferred
		end

	is_ascii_identifier (name: like new_string): BOOLEAN
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

	set_inner_table_field (table: like field_table; name: READABLE_STRING_8; object: EL_REFLECTIVE; value: ANY)
		local
			pos_dot: INTEGER; left_part, right_part: READABLE_STRING_8
		do
			pos_dot := name.index_of ('.', 1)
			if pos_dot > 0 then
				left_part := Immutable_8.shared_substring (name, 1, pos_dot - 1)
				if table.has_imported_key (left_part)
					and then attached {EL_REFLECTIVE} table.found_item.value (object) as inner_object
				then
					right_part := Immutable_8.shared_substring (name, pos_dot + 1, name.count)
					set_inner_table_field (inner_object.field_table, right_part, inner_object, value)
				end

			elseif table.has_imported_key (name) then
				set_reflected_field (table.found_item, object, value)
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

	set_table_field (table: like field_table; name: READABLE_STRING_8; value: ANY)
		do
			if name.has ('.') then
				set_inner_table_field (table, name, current_reflective, value)
			elseif table.has_imported_key (name) then
				set_reflected_field (table.found_item, current_reflective, value)
			end
		end

feature {NONE} -- Constants

	Name_buffer: EL_STRING_8_BUFFER
		once
			create Result
		end

note
	descendants: "[
			EL_SETTABLE_FROM_STRING*
				${EL_SETTABLE_FROM_STRING_32*}
					${MY_DRY_CLASS}
				${EL_SETTABLE_FROM_ZSTRING*}
					${EL_HTML_META_VALUES}
					${PP_TRANSACTION}
					${JOB}
					${COUNTRY}
						${CAMEL_CASE_COUNTRY}
					${FCGI_REQUEST_PARAMETERS}
					${EL_COMMA_SEPARATED_WORDS}
					${PROVINCE}
					${FCGI_HTTP_HEADERS}
					${EL_GVFS_FILE_INFO_COMMAND}
					${PP_SETTABLE_FROM_UPPER_CAMEL_CASE}
						${PP_HTTP_RESPONSE}
							${PP_BUTTON_QUERY_RESULTS}
					${EL_JPEG_FILE_INFO_COMMAND_I*}
						${EL_JPEG_FILE_INFO_COMMAND_IMP}
				${EL_SETTABLE_FROM_STRING_8*}
					${EL_NETWORK_DEVICE_IMP}
					${EL_HTTP_HEADERS}
					${AIA_CREDENTIAL_ID}
					${TB_EMAIL}
					${EL_REFLECTIVE_RSA_KEY*}
						${EL_RSA_PRIVATE_KEY}
						${EL_RSA_PUBLIC_KEY}
					${AIA_AUTHORIZATION_HEADER}
	]"
end