note
	description: "[
		Path steps internally represented as a string of `CHARACTER_32' tokens in attribute `token_list'.
		Tokens are translated back to strings via the shared once-table `Token_table'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-26 14:54:48 GMT (Wednesday 26th December 2018)"
	revision: "15"

class
	EL_PATH_STEPS

inherit
	READABLE_INDEXABLE [ZSTRING]
		redefine
			default_create, is_equal
		end

	HASHABLE
		undefine
			default_create, is_equal
		end

	EL_PATH_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, is_equal
		end

	DEBUG_OUTPUT
		rename
			debug_output as to_string_32
		undefine
			default_create, is_equal
		end

	EL_MODULE_EXECUTION_ENVIRONMENT
		undefine
			default_create, is_equal
		end

	EL_MODULE_DIRECTORY
		undefine
			default_create, is_equal
		end

	EL_MODULE_FILE_SYSTEM
		undefine
			default_create, is_equal
		end

	EL_ZSTRING_ROUTINES
		rename
			joined as joined_iterable
		export
			{NONE} all
		undefine
			default_create, is_equal
		end

	EL_ZSTRING_CONSTANTS
		undefine
			default_create, is_equal
		end

	STRING_HANDLER
		undefine
			default_create, is_equal
		end

create
	default_create, make_with_count, make, make_from_tokens,
	make_from_array, make_from_directory_path, make_from_file_path, make_from_tuple

convert
	make_from_array ({ARRAY [ZSTRING], ARRAY [STRING], ARRAY [STRING_32]}),

	make ({STRING_32, STRING, ZSTRING}), make_from_tuple ({TUPLE}),

	as_file_path: {EL_FILE_PATH}, as_directory_path: {EL_DIR_PATH}, to_string_32: {READABLE_STRING_GENERAL}

feature {NONE} -- Initialization

	default_create
			--
		do
			create token_list.make_empty
		end

	make (a_path: READABLE_STRING_GENERAL)

		local
			sep: CHARACTER_32
		do
			sep:= Separator
			if not a_path.has (sep) then
				-- Uses unix separators as default fall back.
				sep := '/'
			end
			token_list := Token_table.token_list (as_zstring (a_path), sep)
		end

	make_from_array, make_from_strings (a_steps: FINITE [READABLE_STRING_GENERAL])
			-- Create list from array `steps'.
		do
			token_list := Token_table.iterable_to_token_list (a_steps)
		end

	make_from_directory_path, make_from_file_path (a_path: EL_PATH)
		do
			if a_path.parent_path.is_empty then
				create token_list.make_filled (Token_table.token (a_path.base), 1)
			else
				token_list := Token_table.token_list (a_path.parent_path, a_path.Separator)
				token_list.extend (Token_table.token (a_path.base))
			end
		ensure
			same_count: count = a_path.step_count
			reversible_if_directory: attached {EL_DIR_PATH} a_path as dir_path implies dir_path ~ as_directory_path
			reversible_if_file: attached {EL_FILE_PATH} a_path as file_path implies file_path ~ as_file_path
		end

	make_from_tokens (a_tokens: like token_list)
		do
			token_list.wipe_out
			token_list.append (a_tokens)
		end

	make_from_tuple (tuple: TUPLE)
		do
			make_from_strings (create {EL_ZSTRING_LIST}.make_from_tuple (tuple))
		end

	make_with_count (n: INTEGER)
			--
		do
			create token_list.make (n)
		end

feature -- Access

	first: ZSTRING
		require
			not_empty: not is_empty
		do
			if token_list.is_empty then
				create Result.make_empty
			else
				Result := Token_table.token_string (token_list [1])
			end
		end

	item alias "[]" (i: INTEGER): ZSTRING assign put
		-- Item at `i'-th position
		do
			Result := Token_table.token_string (token_list [i])
		end

	last: ZSTRING
		require
			not_empty: not is_empty
		do
			if token_list.is_empty then
				create result.make_empty
			else
				Result := Token_table.token_string (token_list [count])
			end
		end

	to_array: ARRAY [ZSTRING]
		do
			Result := Token_table.string_list (token_list).to_array
		end

feature -- Measurement

	count: INTEGER
			-- step count
		do
			Result := token_list.count
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := token_list.hash_code
		end

	index_of (step: ZSTRING; start_index: INTEGER): INTEGER
		do
			Result := token_list.index_of (Token_table.token (step), start_index)
		end

	upper: INTEGER
			-- step count
		do
			Result := token_list.count
		end

feature -- Element change

	append (steps: EL_PATH_STEPS)
			-- Append a copy of `steps'.
		do
			token_list.append (steps.token_list)
		end

	expand_variables
		local
			l_expanded: EL_PATH_STEPS
		do
			if across Current as step some is_variable_name (step.item) end then
				create l_expanded.make_with_count (count)
				across Current as step loop
					if is_variable_name (step.item)
						and then attached {STRING_32} Execution_environment.item (variable_name (step.item)) as value
					then
						l_expanded.append (create {EL_PATH_STEPS}.make (value))
					else
						l_expanded.extend (step.item)
					end
				end
				token_list := l_expanded.token_list
			end
		end

	extend (step: READABLE_STRING_GENERAL)
			-- Add `step' to end.
			-- Do not move cursor.
		do
			token_list.extend (Token_table.token (as_zstring (step)))
		end

	grow (n: INTEGER)
		do
			token_list.grow (n)
		end

	put (step: ZSTRING; i: INTEGER_32)
			-- Replace `i'-th entry, if in index interval, by `v'.
		require
			valid_index: valid_index (i)
		local
			table: like Token_table
		do
			table := Token_table
			table.put (step)
			token_list.put (table.last_token, i)
		end

	put_front (step: ZSTRING)
		do
			token_list.prepend_character (Token_table.token (as_zstring (step)))
		end

	set_from_string (a_path: READABLE_STRING_GENERAL)
		do
			make (a_path)
		end

feature -- Status query

	has_sub_steps (steps: EL_PATH_STEPS): BOOLEAN
		do
			Result := token_list.has_substring (steps.token_list)
		end

	is_absolute: BOOLEAN
		do
			if not is_empty then
				if {PLATFORM}.is_windows then
					Result := is_volume_name (first)
				else
					Result := first.is_empty
				end
			end
		end

	is_createable_dir: BOOLEAN
			-- True if steps are createable as a directory
		do
			if is_absolute then
				if count > 1 and then sub_steps (1, count - 1).as_directory_path.exists_and_is_writeable then
					Result := true
				end
			else
				Result := Directory.current_working.exists_and_is_writeable
			end
		end

	is_empty: BOOLEAN
		do
			Result := token_list.is_empty
		end

	is_equal (other: like Current): BOOLEAN
		do
			Result := token_list ~ other.token_list
		end

	starts_with (steps: EL_PATH_STEPS): BOOLEAN
		-- `True' if Currrent starts with `steps'
		do
			Result := token_list.starts_with (steps.token_list)
		end

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result := token_list.valid_index (i)
		end

feature -- Conversion

	as_directory_path: EL_DIR_PATH
		do
			create Result
			fill_path (Result)
		end

	as_expanded_directory_path: EL_DIR_PATH
		do
			Result := expanded_path.to_string
		end

	as_expanded_file_path: EL_FILE_PATH
		do
			create Result
			fill_path (Result)
		end

	as_file_path: EL_FILE_PATH
		do
			Result := to_string
		end

	expanded_path: like Current
		do
			Result := twin
			result.expand_variables
		end

	joined (steps: EL_PATH_STEPS): like Current
		do
			create Result.make_with_count (count + steps.count)
			Result.append (Current)
			Result.append (steps)
		end

	last_steps (step_count: INTEGER): like Current
		require
			valid_count: step_count <= count
		do
			Result := sub_steps (count - step_count + 1, count)
		end

	sub_steps (index_from, index_to: INTEGER): like Current
		require
			valid_indices: (1 <= index_from) and (index_from <= index_to) and (index_to <= count)
		do
			create Result.make_from_tokens (token_list.substring (index_from, index_to))
		end

	to_string: ZSTRING
			--
		do
			Result := Token_table.joined (token_list, Separator)
		end

	to_unicode, to_string_32: STRING_32
		do
			Result := to_string.to_unicode
		end

feature -- Removal

	remove (i: INTEGER)
		-- remove i'th step
		require
			valid_index: valid_index (i)
		do
			token_list.remove (i)
		end

	remove_head (n: INTEGER)
		do
			token_list.remove_head (n)
		end

	remove_tail (n: INTEGER)
		do
			token_list.remove_tail (n)
		end

	wipe_out
		do
			token_list.wipe_out
		end

feature -- Basic operations

	fill_path (path: EL_PATH)
		-- set `path' from `Current'
		local
			path_string: ZSTRING; separator_pos: INTEGER
		do
			if is_empty then
				path.wipe_out
			else
				path_string := to_string
				separator_pos := path_string.last_index_of (Separator, path_string.count)
				path.set_base (path_string.substring_end (separator_pos + 1))
				if separator_pos > 0 then
					path_string.remove_tail (path.base.count)
					path.set_parent_path (path_string)
				end
			end
		ensure
			reversible: path.steps ~ Current
		end

feature {NONE} -- Implementation

	is_volume_name (name: ZSTRING): BOOLEAN
		do
			Result := name.count = 2 and then name.is_alpha_item (1) and then name [2] = ':'
		end

	variable_name (step: ZSTRING): STRING_32
		do
			Result := step
			Result.remove_head (1)
		end

feature {EL_PATH_STEPS} -- Internal attributes

	token_list: STRING_32
		-- step tokens

feature {NONE} -- Constants

	Lower: INTEGER = 1

	Token_table: EL_ZSTRING_TOKEN_TABLE
		once
			create Result.make (19)
		end

end
