note
	description: "[
		Thread safe map of file path step tokens to [$source ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-17 9:42:03 GMT (Thursday 17th February 2022)"
	revision: "5"

class
	EL_PATH_STEP_TABLE

inherit
	EL_ARRAYED_LIST [ZSTRING]
		rename
			make as make_list,
			extend as extend_list,
			count as last_token
		export
			{NONE} all
		end

	EL_SINGLE_THREAD_ACCESS
		export
			{NONE} all
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make
		local
			drive: ZSTRING
		do
			make_default
			create index_table.make (1000)
			make_list (index_table.count)
			create drive.make_empty
			-- Unix empty path
			extend (drive)
			token_empty_string := last_token

			if {PLATFORM}.is_windows then
				-- populate with all upper and lower case volume designations
				across ('A').code |..| ('Z').code as code loop
					drive.wipe_out
					drive.append_unicode (code.item.to_natural_32)
					drive.append_character_8 (':')
					extend (drive)
					drive.to_lower
					extend (drive)
				end
			end
			last_drive_token := last_token

			extend (Back_dir_step)
			token_back_dir := last_token
		end

feature -- Access

	token_back_dir: INTEGER

	token_empty_string: INTEGER

	last_drive_token: INTEGER

	to_step (token: INTEGER): ZSTRING
		require
			valid_token: valid_token (token)
		do
			restrict_access
			Result := i_th (token)
			end_restriction
		end

	to_token (str: ZSTRING): INTEGER
		do
			restrict_access
			if index_table.has_key (str) then
				Result := index_table.found_item
			else
				extend (str)
				Result := last_token
			end
			end_restriction
		end

feature -- Status query

	valid_token (token: INTEGER): BOOLEAN
		do
			restrict_access
				Result := valid_index (token)
			end_restriction
		end

	is_less (a, b: INTEGER): BOOLEAN
		do
			restrict_access
				Result := i_th (a).is_less (i_th (b))
			end_restriction
		end

feature -- Measurement

	character_count (tokens: SPECIAL [INTEGER]; a_count: INTEGER): INTEGER
		-- character count
		local
			i: INTEGER; l_area: like area
		do
			restrict_access
				l_area := area
				Result := a_count - 1 -- Separators
				from i := 0 until i = a_count loop
					Result := Result + l_area [tokens [i] - 1].count
					i := i + 1
				end
			end_restriction
		end

feature -- Basic operations

	fill_array (step_array: SPECIAL [ZSTRING]; tokens: SPECIAL [INTEGER]; a_count: INTEGER)
		local
			i: INTEGER; l_area: like area
		do
			restrict_access
				l_area := area
				from i := 0 until i = a_count loop
					step_array.extend (l_area [tokens [i] - 1])
					i := i + 1
				end
			end_restriction
		end

	put_tokens (list: ITERABLE [READABLE_STRING_GENERAL]; tokens: SPECIAL [INTEGER])
		local
			s: EL_ZSTRING_ROUTINES
		do
			restrict_access
				if attached {EL_SPLIT_ZSTRING_ON_CHARACTER} list as splitter then
					across splitter as split loop
						extend_tokens (split.item, tokens)
					end
				else
					across list as str loop
						extend_tokens (s.as_zstring (str.item), tokens)
					end
				end
			end_restriction
		end

	append_to (token: INTEGER; str: ZSTRING)
		require
			valid_token: valid_token (token)
		do
			restrict_access
				str.append (i_th (token))
			end_restriction
		end

feature {NONE} -- Implementation

	extend (step: ZSTRING)
		do
			if not index_table.has (step) then
				extend_list (step.twin)
				index_table.extend (last_token, last)
			end
		end

	extend_tokens (path_step: ZSTRING; tokens: SPECIAL [INTEGER])
		do
			if index_table.has_key (path_step) then
				tokens.extend (index_table.found_item)
			else
				extend (path_step)
				tokens.extend (last_token)
			end
		end

feature {NONE} -- Internal attributes

	index_table: HASH_TABLE [INTEGER, ZSTRING]

feature {NONE} -- Constants

	Back_dir_step: ZSTRING
		once
			Result := ".."
		end

end