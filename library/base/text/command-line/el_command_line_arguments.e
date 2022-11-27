note
	description: "Object to query command line arguments. Accessible via [$source EL_MODULE_ARGS]"
	notes: "[
		As of June 2022 it can now parse options with the form `-name=value' as an alternative to `-name value'.
		This is useful in the case of a value being mistaken for an option if it starts with '-'. In that case you 
		would put: `-name="-not_an_option"'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-23 16:33:58 GMT (Wednesday 23rd November 2022)"
	revision: "19"

class
	EL_COMMAND_LINE_ARGUMENTS

inherit
	ARGUMENTS_32
		rename
			index_of_word_option as internal_index_of_word_option,
			option_sign as option_sign_cell
		export
			{NONE} all
			{ANY} argument_count, new_cursor
		end

	EL_REFLECTION_HANDLER

create
	make

feature {NONE} -- Initialization

	make
		local
			i, equals_index: INTEGER; item: ZSTRING; item_32: STRING_32
		do
			option_sign := option_sign_cell.item

			create is_i_th_option.make_filled (False, 1, argument_count)
			create argument_list.make (argument_count)
			from i := 0 until i > argument_count loop
				item_32 := i_th_argument_string (i)
				if i = 0 then
					command_path := item_32

				elseif is_option (item_32) then
					argument_list.extend (create {ZSTRING}.make_from_substring (item_32, 2, item_32.count))
					is_i_th_option [i] := True
				else
					argument_list.extend (item_32)
				end
				i := i + 1
			end
			create value_table.make_equal (argument_list.count)
			across argument_list as list loop
				item := list.item; i := list.cursor_index
				if is_i_th_option [i] then
--					handle case of -name=value
					equals_index := item.index_of ('=', 1)
					if equals_index > 2 then
						value_table.put (item.substring_end (equals_index + 1), item.substring (1, equals_index - 1))

					elseif i + 1 > argument_list.count or else is_i_th_option [i + 1] then
						value_table.put (Default_value, item)
					else
						value_table.put (argument_list.i_th (i + 1), item)
					end
				end
			end
		end

feature -- Access

	command_path: FILE_PATH

	directory_path (name: READABLE_STRING_GENERAL): DIR_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	file_path (name: READABLE_STRING_GENERAL): FILE_PATH
		require
			has_value: has_value (name)
		do
			Result := value (name)
		end

	i_th (i: INTEGER): ZSTRING
		require
			item_exists: 1 <= i and i <= argument_count
		do
			Result := argument_list.i_th (i).twin
		end

	integer (name: READABLE_STRING_GENERAL): INTEGER
		require
			integer_value_exists: has_integer (name)
		do
			if value_table.has_key (name) and then value_table.found_item.is_integer then
				Result := value_table.found_item.to_integer
			end
		end

	option_name (index: INTEGER): ZSTRING
		do
			if argument_list.valid_index (index) then
				Result := argument_list.i_th (index).twin
				Result.prune_all_leading ('-')
			else
				create Result.make_empty
			end
		end

	remaining_file_paths (name: READABLE_STRING_GENERAL): EL_FILE_PATH_LIST
		local
			l_remaining_items: like remaining_items
		do
			l_remaining_items := remaining_items (name)
			create Result.make_with_count (l_remaining_items.count)
			across l_remaining_items as string loop
				Result.extend (string.item)
			end
		end

	remaining_items (name: READABLE_STRING_GENERAL): EL_ZSTRING_LIST
		local
			index: INTEGER
		do
			index := index_of_word_option (name)
			if 0 < index and index < argument_count then
				Result := argument_list.sub_list (index + 1, argument_count)
			else
				create Result.make_empty
			end
		end

	value (name: READABLE_STRING_GENERAL): ZSTRING
			-- string value of name value pair arguments
		require
			has_value: has_value (name)
		do
			if value_table.has_key (name) and then value_table.found_item /= Default_value then
				Result := value_table.found_item
			else
				create Result.make_empty
			end
		end

feature -- Status query

	character_option_exists (character_option: CHARACTER_32): BOOLEAN
			--
		do
			Result := word_option_exists (character_option.out)
		end

	has_integer (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has_value (name) and then value_table.found_item.is_integer
		end

	has_value (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := value_table.has_key (name) and then value_table.found_item /= Default_value
		end

	is_last_word_option (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			if value_table.has (name) and attached value_table.current_keys as keys then
				Result := keys [keys.upper].same_string_general (name)
			end
		end

	word_option_exists (name: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := value_table.has (name)
		end

feature -- Measurement

	index_of_word_option (name: READABLE_STRING_GENERAL): INTEGER

		do
			across argument_list as list until Result.to_boolean loop
				if is_i_th_option [list.cursor_index]
					and then attached list.item as item
					and then item.starts_with_general (name)
					and then (item.count = name.count or else item [name.count + 1] = '=')
				then
					Result := list.cursor_index
				end
			end
		end

feature -- Basic operations

	set_attributes (object: EL_REFLECTIVE)
		-- set attribute in object that match command command options
		do
			across object.field_table as table loop
				if value_table.has_key (table.key) then
					if attached {EL_REFLECTED_BOOLEAN} table.item as boolean then
						boolean.set (object, True)
					elseif attached {EL_REFLECTED_BOOLEAN_REF} table.item as boolean then
						boolean.set_from_integer (object, 1)
					else
						table.item.set_from_string (object, value_table.found_item)
					end
				end
			end
		end

feature {NONE} -- Implementation

	is_option (str: STRING_32): BOOLEAN
		-- `True' if `str' appears to be a command line option or has form: -name=value
		local
			c: CHARACTER_32; found_equals: BOOLEAN
		do
			Result := str.count >= 2
			across str as char until not Result or found_equals loop
				c := char.item
				inspect char.cursor_index
					when 1 then
						Result := c = option_sign
					when 2 then
						Result := c.is_alpha
				else
					if c = '=' then
						found_equals := True
					else
						Result := c.is_alpha_numeric or else c = '_'
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	argument_list: EL_ZSTRING_LIST

	is_i_th_option: ARRAY [BOOLEAN]

	option_sign: CHARACTER_32

	value_table: EL_ZSTRING_HASH_TABLE [ZSTRING]

feature {NONE} -- Constants

	Default_value: ZSTRING
		once ("PROCESS")
			create Result.make_empty
		end

end