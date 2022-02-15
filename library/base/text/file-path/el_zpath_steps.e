note
	description: "[
		A series of path steps represented as a [$source ARRAYED_LIST] of shared path-step tokens
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 18:10:34 GMT (Tuesday 15th February 2022)"
	revision: "3"

class
	EL_ZPATH_STEPS

inherit
	ARRAYED_LIST [INTEGER]
		rename
			make as make_steps,
			index_of as index_of_token,
			count as step_count
		export
			{NONE} all
			{ANY} append, extend, extendible, occurrences, put_i_th, i_th, is_equal, step_count, is_empty, prunable, valid_index, put_front, last, first
			{EL_ZPATH_STEPS} area
		redefine
			default_create, wipe_out, put_front
		end

	EL_PATH_STEPS_IMPLEMENTATION

	COMPARABLE
		undefine
			copy, default_create, is_equal
		end

feature -- Initialization

	default_create
		do
			make_steps (0)
		end

	make, set_path (a_path: READABLE_STRING_GENERAL)
		do
			if a_path.is_empty then
				default_create
			else
				make_steps (a_path.occurrences (Separator) + 1)
				Step_table.put_tokens (temporary_copy (a_path).split (Separator), area)
			end
		ensure
			reversible: to_string.same_string (a_path)
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

	make_parent (other: EL_PATH)
		require
			has_parent: other.has_parent
		local
			l_count: INTEGER
		do
			l_count := other.step_count - 1
			make_steps (l_count)
			area.copy_data (other.area, 0, 0, l_count)
		end

	make_sub_path (other: EL_PATH; start_index: INTEGER)
		require
			valid_start_index: other.valid_index (start_index) or start_index = other.step_count + 1
		local
			l_count: INTEGER
		do
			l_count := other.step_count - start_index + 1
			make_steps (l_count)
			if l_count.to_boolean then
				area.copy_data (other.area, start_index - 1, 0, l_count)
			end
		end

feature -- Access

	i_th_step (a_index: INTEGER): ZSTRING
		do
			Result := internal_i_th_step (a_index).twin
		end

feature -- Measurement

	count: INTEGER
		-- character count
		-- (works for uri paths too)
		do
			Result := Step_table.character_count (area, step_count)
		end

	index_of (step: READABLE_STRING_GENERAL; start_index: INTEGER): INTEGER
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := index_of_token (Step_table.to_token (s.as_zstring (step)), start_index)
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
			from i := 1 until i > step_count loop
				if i_th (i) = Step_table.token_back_dir then
					Result := Result + 1
				else
					i := step_count
				end
				i := i + 1
			end
		end

feature -- Status query

	has_step (step: READABLE_STRING_GENERAL): BOOLEAN
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := has (Step_table.to_token (s.as_zstring (step)))
		end

	has_sub_steps (other: EL_ZPATH_STEPS): BOOLEAN
		local
			token_string, other_token_string: STRING_32
		do
			across Reuseable.string_32_pool as pool loop
				token_string := pool.borrowed_item
				other_token_string := pool.borrowed_item
				append_tokens_to (token_string)
				other.append_tokens_to (other_token_string)
				Result := token_string.has_substring (other_token_string)
			end
		end

	is_absolute: BOOLEAN
		do
			Result := step_count > 0 and then i_th (1) <= Step_table.last_drive_token
		end

	starts_with (other: EL_ZPATH_STEPS): BOOLEAN
		local
			i: INTEGER
		do
			if other.step_count <= step_count then
				Result := True
				from i := 1 until not Result or i > other.step_count loop
					Result := i_th (i) = other.i_th (i)
					i := i + 1
				end
			end
		end

	same_i_th_step (str: READABLE_STRING_GENERAL; i: INTEGER): BOOLEAN
		do
			if valid_index (i) then
				Result := internal_i_th_step (i).same_string (str)
			end
		end

feature -- Conversion

	escaped: ZSTRING
		-- escaped for use as command line argument
		-- On Unix characters like colon, space etc are prefixed with a backslash
		-- On Windows this results in a quoted string
		do
			Result := File_system.escaped_path (temporary_path)
		end

	to_path: PATH
		local
			str: STRING_32; buffer: EL_STRING_32_BUFFER_ROUTINES
		do
			str := buffer.empty
			append_to_32 (str)
			create Result.make_from_string (str)
		end

	to_string: ZSTRING
		do
			Result := filled_list.joined (Separator)
		end

	to_string_32, as_string_32: STRING_32
		do
			if attached filled_list as filled then
				create Result.make (step_count - 1 + filled.character_count)
				across filled as list loop
					if not list.is_first then
						Result.append_character (Separator)
					end
					list.item.append_to_string_32 (Result)
				end
			end
		end

	to_unix, as_unix: ZSTRING
		do
			Result := filled_list.joined (Unix_separator)
		end

	to_uri: EL_URI
		local
			uri: like empty_uri_path
		do
			uri := empty_uri_path
			append_to_uri (uri)
			create Result.make (uri)
		end

	to_utf_8: STRING
		do
			across Reuseable.string_8 as reuse loop
				across filled_list as step loop
					if step.cursor_index > 1 then
						reuse.item.append_character (Separator.to_character_8)
					end
					step.item.append_to_utf_8 (reuse.item)
				end
				Result := reuse.item.twin
			end
		end

	to_windows, as_windows: ZSTRING
		do
			Result := filled_list.joined (Windows_separator)
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

feature -- Element change

	append_dir_path (a_dir_path: DIR_PATH)
		do
			append_path (a_dir_path)
		end

	append_path (path: EL_PATH)
		require
			enough_steps: valid_back_step_count >= path.leading_backstep_count
		local
			backstep_count: INTEGER
		do
			backstep_count := path.leading_backstep_count
			if backstep_count > 0 then
				area_v2.remove_tail (backstep_count.min (step_count))
				if path.step_count - backstep_count > 0 then
					if last_is_empty then
						area.remove_tail (1)
					end
					append_subpath (path, backstep_count + 1)
				end
			elseif not path.is_empty then
				if last_is_empty then
					area.remove_tail (1)
				end
				if path.first = Step_table.token_empty_string then
					append_subpath (path, 2)
				else
					append (path)
				end
			end
			internal_hash_code := 0
		end

	append_step (a_step: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_BUFFER_ROUTINES
		do
			extend (Step_table.to_token (s.copied_general (a_step)))
			internal_hash_code := 0
		end

	expand
		-- expand environment variables in each step
		local
			factory: EL_ITERABLE_SPLIT_FACTORY_ROUTINES; new_tokens: ARRAYED_LIST [INTEGER]
		do
			if attached filled_list as filled and then filled.there_exists (agent has_expansion_variable) then
				create new_tokens.make (step_count)
				across filled as list loop
					if has_expansion_variable (list.item)
						and then attached Execution_environment.item (variable_name (list.item)) as value
					then
						new_tokens.grow (new_tokens.count + value.occurrences (Separator) + 1)
						Step_table.put_tokens (factory.new_split_on_character (value, Separator), new_tokens.area)
					else
						new_tokens.extend (i_th (list.cursor_index))
					end
				end
				area_v2 := new_tokens.area
				internal_hash_code := 0
			end
		end

	put_base (a_step: ZSTRING)
		require
			not_empty: step_count > 0
		do
			put_i_th (Step_table.to_token (a_step), step_count)
			internal_hash_code := 0
		end

	put_front (step_token: INTEGER)
		do
			Precursor (step_token)
			internal_hash_code := 0
		end

	put_i_th_step (step: READABLE_STRING_GENERAL; a_index: INTEGER)
		local
			s: EL_ZSTRING_ROUTINES
		do
			if valid_index (a_index) then
				put_i_th (Step_table.to_token (s.as_zstring (step)), a_index)
				internal_hash_code := 0
			end
		end

	put_step_front (step: READABLE_STRING_GENERAL)
		local
			s: EL_ZSTRING_ROUTINES
		do
			put_front (Step_table.to_token (s.as_zstring (step)))
			internal_hash_code := 0
		ensure
			is_set: internal_i_th_step (1).same_string (step)
		end

feature -- Removal

	prune_until (last_step: READABLE_STRING_GENERAL)
		-- prune until last step value is `last_step' or else is empty
		local
			s: EL_ZSTRING_ROUTINES; token: INTEGER
		do
			token := Step_table.to_token (s.as_zstring (last_step))
			from until not is_empty or else last = token loop
				remove_tail (1)
			end
		ensure
			same_last_step: not is_empty implies internal_i_th_step (step_count).same_string (last_step)
		end

	remove_head (n: INTEGER)
		do
			area.remove_head (n.min (step_count))
			internal_hash_code := 0
		end

	remove_tail (n: INTEGER)
		do
			area.remove_tail (n.min (step_count))
			internal_hash_code := 0
		end

	wipe_out
		do
			Precursor
			internal_hash_code := 0
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
		-- Is current object less than `other'?
		local
			i: INTEGER; step_differs: BOOLEAN
			token, other_token: INTEGER
		do
			from i := 1 until i > step_count or i > other.step_count or step_differs loop
				token := i_th (i); other_token := other.i_th (i)
				if token /= other_token then
					step_differs := True
				else
					i := i + 1
				end
			end
			if step_differs then
				Result := Step_table.is_less (token, other_token)
			else
				Result := step_count < other.step_count
			end
		end

feature -- Contract Support

	valid_back_step_count: INTEGER
		local
			i: INTEGER
		do
			from i := step_count until i = 0 or else i_th (i) = Step_table.token_empty_string loop
				Result := Result + 1
				i := i - 1
			end
		end

feature {EL_ZPATH_STEPS} -- Implementation

	append_subpath (path: EL_PATH; from_index: INTEGER)
		require
			valid_index: 1 <= from_index and then from_index <= path.step_count
		local
			i: INTEGER
		do
			grow (step_count + path.step_count - from_index + 1)
			from i := from_index until i > path.step_count loop
				extend (path [i])
				i := i + 1
			end
			internal_hash_code := 0
		end

	append_tokens_to (str: STRING_32)
		local
			i: INTEGER
		do
			from i := 1 until i > step_count loop
				str.append_code (i_th (i).to_natural_32)
				i := i + 1
			end
		end

	filled_list: EL_ZSTRING_LIST
		do
			Result := Step_list
			Result.wipe_out
			Result.grow (step_count)
			if step_count = 1 and then first = Step_table.token_empty_string then
				Result.extend (Forward_slash)
			else
				Step_table.fill_array (Result.area, area, step_count)
			end
		end

	internal_i_th_step (a_index: INTEGER): ZSTRING
		do
			if valid_index (a_index) then
				Result := Step_table.to_step (i_th (a_index))
			else
				Result := Empty_string
			end
		end

	internal_base: ZSTRING
		do
			if is_empty then
				create Result.make_empty
			else
				Result := Step_table.to_step (i_th (step_count))
			end
		end

	last_is_empty: BOOLEAN
		do
			Result := step_count > 0 and then last = Step_table.token_empty_string
		end

feature {EL_ZPATH_STEPS} -- Internal attributes

	internal_hash_code: INTEGER


end