note
	description: "Object to query command line arguments. Accessible via [$source EL_MODULE_ARGS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-11 11:54:21 GMT (Friday 11th February 2022)"
	revision: "13"

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

create
	make

feature {NONE} -- Initialization

	make
		local
			i: INTEGER; item: ZSTRING
		do
			option_sign := option_sign_cell.item

			create internal_option_key.make_empty
			create list.make (argument_count + 1)
			from i := 0 until i > argument_count loop
				create item.make_from_general (argument (i))
				if i = 0 then
					command_path := item
				else
					list.extend (item)
				end
				i := i + 1
			end
			create table.make_equal (list.count)
			from list.start until list.after loop
				item := list.item
				if is_option (item) then
					if list.index + 1 > list.count then
						table.put (create {EL_ZSTRING}.make_empty, item)
					else
						table.put (list.i_th (list.index + 1), item)
					end
				end
				list.forth
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
			Result := list.i_th (i).twin
		end

	integer (name: READABLE_STRING_GENERAL): INTEGER
		require
			integer_value_exists: has_integer (name)
		do
			if table.has_key (option_key (name)) and then table.found_item.is_integer then
				Result := table.found_item.to_integer
			end
		end

	option_name (index: INTEGER): ZSTRING
		do
			if list.valid_index (index) then
				Result := list.i_th (index).twin
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
				Result := list.sub_list (index + 1, argument_count)
			else
				create Result.make_empty
			end
		end

	value (name: READABLE_STRING_GENERAL): ZSTRING
			-- string value of name value pair arguments
		require
			has_value: has_value (name)
		do
			if table.has_key (option_key (name)) and then not is_option (table.found_item) then
				Result := table.found_item
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
			Result := table.has_key (option_key (name)) and then table.found_item.is_integer
		end

	has_value (name: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := table.has_key (option_key (name)) and then not is_option (table.found_item)
		end

	word_option_exists (name: READABLE_STRING_GENERAL): BOOLEAN
			--
		do
			Result := table.has (option_key (name))
		end

feature -- Measurement

	index_of_word_option (name: READABLE_STRING_GENERAL): INTEGER
		do
			Result := list.index_of (option_key (name), 1)
		end

feature {NONE} -- Implementation

	option_key (opt: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := internal_option_key
			Result.wipe_out
			Result.append_character (option_sign)
			Result.append_string_general (opt)
		end

	is_option (str: ZSTRING): BOOLEAN
		-- true if `str' appears to be a command line option
		do
			Result := str.count >= 2
			across str as chr until not Result loop
				inspect chr.cursor_index
					when 1 then
						Result := chr.item = option_sign
					when 2 then
						Result := chr.item.is_alpha
				else
					Result := chr.item.is_alpha_numeric or else chr.item = '_'
				end
			end
		end

feature {NONE} -- Internal attributes

	option_sign: CHARACTER_32

	list: EL_ZSTRING_LIST

	table: EL_ZSTRING_HASH_TABLE [ZSTRING]

	internal_option_key: ZSTRING

end