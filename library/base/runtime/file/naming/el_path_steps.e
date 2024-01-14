note
	description: "[
		A series of path steps represented as a [$source ARRAYED_LIST] of shared path-step tokens
	]"
	notes: "[
		`Step_table', a once per process instance, stores a table of step tokens. Access is thread-safe.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 9:38:55 GMT (Sunday 14th January 2024)"
	revision: "20"

class
	EL_PATH_STEPS

inherit
	EL_PATH_STEPS_IMPLEMENTATION
		undefine
			is_equal
		redefine
			default_create
		end

	READABLE_INDEXABLE [ZSTRING]
		rename
			upper as count
		undefine
			default_create, is_equal
		end

	COMPARABLE
		undefine
			default_create
		end

	HASHABLE
		undefine
			default_create, is_equal
		end

	EL_STRING_GENERAL_ROUTINES

create
	default_create, make, make_from_path, make_from_steps, make_from_tuple, make_steps

convert
	make_from_steps ({ARRAY [ZSTRING], ARRAY [STRING], ARRAY [STRING_32]}),
	make ({STRING, STRING_32, IMMUTABLE_STRING_32, IMMUTABLE_STRING_8, ZSTRING}),

	as_string_32: {STRING_32, READABLE_STRING_GENERAL}, to_string: {ZSTRING},
	to_dir_path: {DIR_PATH}, to_file_path: {FILE_PATH}

feature -- Initialization

	default_create
		do
			make_steps (0)
		end

	make, set_path (a_path: READABLE_STRING_GENERAL)
		local
			separator_count: INTEGER; l_separator: CHARACTER_32
		do
			if a_path.is_empty then
				default_create
			else
				l_separator := Separator
				separator_count := a_path.occurrences (l_separator)
				if separator_count = 0 and then {PLATFORM}.is_windows and a_path.substring_index (Colon_slash_x2, 1) = 0 then
					l_separator := Unix_separator
					separator_count := a_path.occurrences (l_separator)
				end
				make_steps (separator_count + 1)

				if separator_count = 0 then
					extend (a_path)
				else
					Step_table.put_tokens (temporary_copy (a_path).split (l_separator), area)
				end
			end
		ensure
			reversible: filled_list.joined (Separator) ~ normalized (a_path)
		end

	make_from_path (a_path: PATH)
		do
			make (a_path.name)
		end

	make_from_steps (a_steps: ITERABLE [READABLE_STRING_GENERAL])
		do
			make_steps (Iterable.count (a_steps))
			Step_table.put_tokens (a_steps, area)
		ensure
			reversible: filled_list ~ create {like filled_list}.make_from_general (a_steps)
		end

	make_from_tuple (a_tuple: TUPLE)
		do
			make_from_steps (create {EL_ZSTRING_LIST}.make_from_tuple (a_tuple))
		end

	make_parent (other: EL_PATH_STEPS)
		require
			has_parent: other.has_parent
		local
			l_count: INTEGER
		do
			l_count := other.count - 1
			make_steps (l_count)
			area.copy_data (other.area, 0, 0, l_count)
		end

	make_steps (n: INTEGER)
		do
			create area.make_empty (n)
		end

	make_sub_path (other: EL_PATH_STEPS; start_index: INTEGER)
		require
			valid_start_index: other.valid_index (start_index) or start_index = other.count + 1
		local
			l_count: INTEGER
		do
			l_count := other.count - start_index + 1
			make_steps (l_count)
			if l_count.to_boolean then
				area.copy_data (other.area, start_index - 1, 0, l_count)
			end
		end

feature -- Access

	base: ZSTRING
		-- last step value
		-- WARNING: shared instance do not modify, use `set_base' to change
		do
			Result := internal_base.twin
		end

	first: ZSTRING
		do
			if is_absolute then
				if count > 1 then
					Result := Step_table.to_step (i_th_token (2)).twin
				else
					create Result.make_empty
				end

			elseif count > 0 then
				Result := Step_table.to_step (i_th_token (1)).twin

			else
				create Result.make_empty
			end
		end

	item alias "[]" (a_index: INTEGER): ZSTRING assign put
		do
			Result := internal_i_th_step (a_index).twin
		end

feature -- Conversion

	to_dir_path: DIR_PATH
		do
			create Result.make (filled_list.joined (Separator))
		end

	to_file_path: FILE_PATH
		do
			create Result.make (filled_list.joined (Separator))
		end

	to_list: EL_ZSTRING_LIST
		do
			Result := filled_list.twin
		end

	to_list_32: EL_STRING_32_LIST
		do
			create Result.make_from_general (filled_list)
		end

	to_string: ZSTRING
		do
			Result := filled_list.joined (Separator)
		end

	to_string_32, as_string_32: STRING_32
		do
			if attached filled_list as filled then
				create Result.make (count - 1 + filled.character_count)
				across filled as list loop
					if not list.is_first then
						Result.append_character (Separator)
					end
					list.item.append_to_string_32 (Result)
				end
			end
		end

feature -- Measurement

	character_count: INTEGER
		-- character count
		-- (works for uri paths too)
		do
			Result := Step_table.character_count (area, count)
		end

	frozen lower: INTEGER
		do
			Result := 1
		end

	hash_code: INTEGER
		-- Hash code value
		local
			i: INTEGER
		do
			Result := internal_hash_code
			if Result = 0 then
				from i := 1 until i > count loop
					Result := ((Result \\ 8388593) |<< 8) + i_th_token (i)
					i := i + 1
				end
				Result := Result.abs
				internal_hash_code := Result
			end
		end

	index_of (step: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		do
			if attached token_list as list then
				Result := list.sequential_index_of (Step_table.to_token (as_zstring (step)), start_index)
			end
		end

	index_of_true (is_step: PREDICATE [EL_ZSTRING]; start_index: INTEGER): INTEGER
		-- returns first index from `start_index' where `is_step (item (index))' is `True'
		do
			across filled_list as list until Result > 0 loop
				if list.cursor_index >= start_index and then is_step (list.item) then
					Result := list.cursor_index
				end
			end
		end

	leading_backstep_count: INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				if i_th_token (i) = Step_table.token_back_dir then
					Result := Result + 1
				else
					i := count
				end
				i := i + 1
			end
		end

feature -- Status query

	has_parent: BOOLEAN
		do
			Result := count > 1
		end

	has_step (step: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := has (Step_table.to_token (as_zstring (step)))
		end

	has_sub_steps (other: EL_PATH_STEPS): BOOLEAN
		local
			token_string, other_token_string: STRING_32
		do
			across String_32_pool_scope as pool loop
				token_string := pool.borrowed_item
				other_token_string := pool.borrowed_item
				append_tokens_to (token_string)
				other.append_tokens_to (other_token_string)
				Result := token_string.has_substring (other_token_string)
			end
		end

	is_absolute: BOOLEAN
		do
			Result := count > 0 and then i_th_token (1) <= Step_table.last_drive_token
		end

	is_empty: BOOLEAN
		do
			Result := area.count = 0
		end

	is_uri: BOOLEAN
		do
			if count >= 3 and then i_th_token (2) = Step_table.token_empty_string
				and then attached item (1) as l_first
			then
				Result := l_first.is_ascii and then l_first [l_first.count] = ':'
			end
		end

	same_i_th_step (str: READABLE_STRING_GENERAL; i: INTEGER): BOOLEAN
		do
			if valid_index (i) then
				Result := internal_i_th_step (i).same_string_general (str)
			end
		end

	starts_with (other: EL_PATH_STEPS): BOOLEAN
		local
			i: INTEGER
		do
			if other.count <= count then
				Result := True
				from i := 1 until not Result or i > other.count loop
					Result := i_th_token (i) = other.i_th_token (i)
					i := i + 1
				end
			end
		end

feature -- Basic operations

	append_to (str: EL_APPENDABLE_ZSTRING)
		-- append path to string `str'
		do
			if attached filled_list as filled then
				str.grow (str.count + filled.joined_character_count)
				across filled as step loop
					if step.cursor_index > 1 then
						str.append_character (Separator)
					end
					str.append (step.item)
				end
			end
		end

	append_to_32 (str: STRING_32)
		-- append path to string `str'
		do
			if attached filled_list as filled then
				str.grow (str.count + filled.joined_character_count)
				across filled as step loop
					if step.cursor_index > 1 then
						str.append_character (Separator)
					end
					step.item.append_to_string_32 (str)
				end
			end
		end

	append_to_uri (uri: EL_URI_STRING_8)
		do
			if is_absolute then
				uri.append_raw_8 (Protocol.file)
				uri.append_raw_8 (Colon_slash_x2)

				if {PLATFORM}.is_windows then
					uri.append_character ('/')
				end
			end
			if attached filled_list as filled then
				uri.grow (uri.count + filled.joined_character_count)
				across filled as step loop
					if step.cursor_index > 1 then
						uri.append_character (Unix_separator.to_character_8)
					end
					uri.append_general (step.item)
				end
			end
		end

	write_to (a_output: EL_WRITABLE)
		local
			not_first: BOOLEAN
		do
			across filled_list as step loop
				if not_first then
					a_output.write_character_32 (Unix_separator.to_character_8)
				else
					not_first := True
				end
				a_output.write_string (step.item)
			end
		end

feature -- Element change

	append_dir_path (a_dir_path: DIR_PATH)
		do
			append_path (a_dir_path)
		end

	append_path (path: EL_PATH_STEPS)
		require
			enough_steps: valid_back_step_count >= path.leading_backstep_count
		local
			backstep_count: INTEGER
		do
			backstep_count := path.leading_backstep_count
			if backstep_count > 0 then
				area.remove_tail (backstep_count.min (count))
				if path.count - backstep_count > 0 then
					if last_is_empty then
						area.remove_tail (1)
					end
					append_subpath (path, backstep_count + 1)
				end
			elseif not path.is_empty then
				if last_is_empty then
					area.remove_tail (1)
				end
				if path.first_token = Step_table.token_empty_string then
					append_subpath (path, 2)
				else
					append (path)
				end
			end
			internal_hash_code := 0
		end

	extend (a_step: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_BUFFER_ROUTINES
		do
			extend_token (Step_table.to_token (s.copied_general (a_step)))
			internal_hash_code := 0
		end

	expand
		-- expand environment variables in each step
		local
			new_tokens: ARRAYED_LIST [INTEGER]
		do
			if attached filled_list as filled and then filled.there_exists (agent has_expansion_variable) then
				create new_tokens.make (count)
				across filled as list loop
					if has_expansion_variable (list.item)
						and then attached Execution_environment.item (variable_name (list.item)) as value
					then
						new_tokens.grow (new_tokens.count + value.occurrences (Separator) + 1)
						Step_table.put_tokens (value.split (Separator), new_tokens.area)
					else
						new_tokens.extend (i_th_token (list.cursor_index))
					end
				end
				area := new_tokens.area
				internal_hash_code := 0
			end
		end

	keep_head (n: INTEGER)
		-- keep first `n' steps
		require
			small_enough: n <= count
		do
			remove_tail (count - n.min (count))
		end

	put_base (a_step: ZSTRING)
		require
			not_empty: count > 0
		do
			put (a_step, count)
		end

	put_general (step: READABLE_STRING_GENERAL; a_index: INTEGER)
		do
			put (as_zstring (step), a_index)
		end

	put (step: ZSTRING; a_index: INTEGER)
		do
			if valid_index (a_index) then
				put_i_th_token (Step_table.to_token (step), a_index)
				internal_hash_code := 0
			end
		end

	put_front (step: READABLE_STRING_GENERAL)
		do
			put_token_front (Step_table.to_token (as_zstring (step)))
		ensure
			is_set: internal_i_th_step (1).same_string_general (step)
		end

	set_base (a_base: READABLE_STRING_GENERAL)
		do
			if count = 0 then
				extend (a_base)
			else
				put_base (as_zstring (a_base))
				internal_hash_code := 0
			end
		ensure
			base_set: internal_base.same_string_general (a_base)
		end

feature -- Removal

	keep_tail (n: INTEGER)
			-- Keep the last `n' entries.
		require
			non_negative_argument: n >= 0
			less_than_count: n <= count
		do
			area.overlapping_move (count - n, 0, n)
			area.keep_head (n)
		ensure
			count_updated: count = n
		end

	prune_until (last_step: READABLE_STRING_GENERAL)
		-- prune until last step value is `last_step' or else is empty
		local
			token: INTEGER
		do
			token := Step_table.to_token (as_zstring (last_step))
			from until is_empty or else last_token = token loop
				area.remove_tail (1)
			end
			internal_hash_code := 0
		ensure
			same_last_step: not is_empty implies internal_i_th_step (count).same_string_general (last_step)
		end

	remove (a_index: INTEGER)
		do
			if attached token_list as list and then list.valid_index (a_index) then
				list.go_i_th (a_index)
				list.remove
			end
			internal_hash_code := 0
		end

	remove_head (n: INTEGER)
		do
			keep_tail (count - n)
			internal_hash_code := 0
		end

	remove_tail (n: INTEGER)
		do
			area.keep_head (count - n)
			internal_hash_code := 0
		end

	wipe_out
		do
			area.wipe_out
			internal_hash_code := 0
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
		-- Is current object less than `other'?
		local
			i: INTEGER; step_differs: BOOLEAN
			token, other_token: INTEGER
		do
			from i := 1 until i > count or i > other.count or step_differs loop
				token := i_th_token (i); other_token := other.i_th_token (i)
				if token /= other_token then
					step_differs := True
				else
					i := i + 1
				end
			end
			if step_differs then
				Result := Step_table.is_less (token, other_token)
			else
				Result := count < other.count
			end
		end

feature -- Contract Support

	normalized (a_path: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (a_path)
			if {PLATFORM}.is_windows then
				Result.replace_character (Unix_separator, Separator)
			else
				Result.replace_character (Windows_separator, Separator)
			end
		end

	valid_back_step_count: INTEGER
		local
			i: INTEGER
		do
			from i := count until i = 0 or else i_th_token (i) = Step_table.token_empty_string loop
				Result := Result + 1
				i := i - 1
			end
		end

feature {EL_PATH_STEPS} -- Implementation

	append_subpath (path: EL_PATH_STEPS; from_index: INTEGER)
		require
			valid_index: 1 <= from_index and then from_index <= path.count
		local
			i: INTEGER
		do
			if attached token_list as list then
				list.grow (count + path.count - from_index + 1)
				area := list.area
			end
			from i := from_index until i > path.count loop
				area.extend (path.i_th_token (i))
				i := i + 1
			end
			internal_hash_code := 0
		end

	append_tokens_to (str: STRING_32)
		local
			i: INTEGER
		do
			from i := 1 until i > count loop
				str.append_code (i_th_token (i).to_natural_32)
				i := i + 1
			end
		end

	filled_list: EL_ZSTRING_LIST
		do
			Result := Step_list
			Result.wipe_out
			Result.grow (count)
			if count = 1 and then first_token = Step_table.token_empty_string then
				Result.extend (Forward_slash)
			else
				Step_table.fill_array (Result.area, area, count)
			end
		end

	internal_base: ZSTRING
		-- never modify or keep as reference
		do
			if is_empty then
				Result := Empty_string
			else
				Result := Step_table.to_step (i_th_token (count))
			end
		end

	internal_i_th_step (a_index: INTEGER): ZSTRING
		do
			if valid_index (a_index) then
				Result := Step_table.to_step (i_th_token (a_index))
			else
				Result := Empty_string
			end
		end

	last_is_empty: BOOLEAN
		do
			Result := count > 0 and then last_token = Step_table.token_empty_string
		end

end