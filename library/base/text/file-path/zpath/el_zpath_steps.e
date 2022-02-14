note
	description: "[
		A series of path steps represented as a [$source ARRAYED_LIST] of shared path-step tokens
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 19:33:32 GMT (Monday 14th February 2022)"
	revision: "1"

class
	EL_ZPATH_STEPS

inherit
	ARRAYED_LIST [INTEGER]
		rename
			make as make_tokens,
			index_of as index_of_token,
			count as step_count
		export
			{NONE} all
			{ANY} append, is_equal, step_count, is_empty, prunable
			{EL_ZPATH_STEPS} area, i_th, occurrences, put_front, put_i_th
		redefine
			default_create, wipe_out
		end

	COMPARABLE
		undefine
			copy, default_create, is_equal
		end

	EL_MODULE_FILE_SYSTEM; EL_MODULE_ITERABLE

	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	EL_ZSTRING_CONSTANTS

feature -- Initialization

	default_create
		do
			make_tokens (0)
		end

	make, set_path (a_path: READABLE_STRING_GENERAL)
		do
			if a_path.is_empty then
				default_create
			else
				make_tokens (a_path.occurrences (Separator) + 1)
				Step_table.put_tokens (temporary_copy (a_path).split (Separator), area)
			end
		ensure
			reversible: to_string.same_string (a_path)
		end

	make_from_other (other: EL_ZPATH_STEPS)
		do
			area_v2 := other.area.twin
			internal_hash_code := other.internal_hash_code
		ensure
			same_string: to_string ~ other.to_string
		end

	make_from_steps (a_steps: ITERABLE [READABLE_STRING_GENERAL])
		do
			make_tokens (Iterable.count (a_steps))
			Step_table.put_tokens (a_steps, area)
		ensure
			reversible: filled_list ~ create {like filled_list}.make_from_general (a_steps)
		end

	make_from_tuple (tuple: TUPLE)
		do
			make_from_steps (create {EL_ZSTRING_LIST}.make_from_tuple (tuple))
		end

	make_parent (other: EL_ZPATH)
		require
			has_parent: other.has_parent
		local
			count: INTEGER
		do
			count := other.step_count - 1
			make_tokens (count)
			area.copy_data (other.area, 0, 0, count)
		end

feature -- Measurement

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

	is_absolute: BOOLEAN
		do
			Result := step_count > 0 and then i_th (1) <= Step_table.last_drive_token
		end

feature -- Conversion

	as_string_32: STRING_32
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

	escaped: ZSTRING
		-- escaped for use as command line argument
		-- On Unix characters like colon, space etc are prefixed with a backslash
		-- On Windows this results in a quoted string
		do
			Result := File_system.escaped_path (temporary_path)
		end

	to_string: ZSTRING
		do
			Result := filled_list.joined (Separator)
		end

feature -- Basic operations

	append_to (str: EL_ZSTRING)
		-- append path to string `str'
		do
			if attached filled_list as filled then
				if {PLATFORM}.is_unix and then filled.count = 1 and then filled.first.is_empty then
					str.append_character_8 ('.')
				else
					str.grow (str.count + filled.character_count + (filled.count - 1))
					across filled as step loop
						if step.cursor_index > 1 then
							str.append_character (Separator)
						end
						str.append (step.item)
					end
				end
			end
		end

feature -- Element change

	put_base (a_step: ZSTRING)
		require
			not_empty: step_count > 0
		do
			put_i_th (Step_table.to_token (a_step), step_count)
		end

feature -- Removal

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

feature {EL_ZPATH_STEPS} -- Implementation

	filled_list: EL_ZSTRING_LIST
		do
			Result := Step_list
			Result.wipe_out
			Result.grow (step_count)
			Step_table.fill_array (Result.area, area, step_count)
			if {PLATFORM}.is_unix and then Result.count = 1 and then Result.first.is_empty then
				Result [1] := Forward_slash
			end
		end

	has_expansion_variable (a_path: ZSTRING): BOOLEAN
		-- a step contains what might be an expandable variable
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else a_path [pos_dollor - 1] = Separator)
		end

	i_th_step (a_index: INTEGER): ZSTRING
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

	put_i_th_step (step: READABLE_STRING_GENERAL; a_index: INTEGER)
		local
			s: EL_ZSTRING_ROUTINES
		do
			if valid_index (a_index) then
				put_i_th (Step_table.to_token (s.as_zstring (step)), a_index)
			end
		end

	temporary_copy (path: READABLE_STRING_GENERAL): ZSTRING
		do
			Result := Temp_path
			if Result /= path then
				Result.wipe_out
				Result.append_string_general (path)
			end
		end

	temporary_path: ZSTRING
		-- temporary shared copy of current path
		do
			Result := Temp_path
			Result.wipe_out
			append_to (Result)
		end

	variable_name (step: ZSTRING): STRING_32
		do
			Result := step
			Result.remove_head (1)
		end

feature {EL_ZPATH_STEPS} -- Internal attributes

	internal_hash_code: INTEGER

feature {NONE} -- Constants

	Shared_base: ZSTRING
		once
			create Result.make_empty
		end

	Step_list: EL_ZSTRING_LIST
		once
			create Result.make (0)
		end

	Step_table: EL_PATH_STEP_TABLE
		once ("PROCESS")
			create Result.make
		end

	Temp_path: ZSTRING
		once
			create Result.make_empty
		end

	Temporary_dir: EL_DIR_ZPATH
		once
			create Result
		end
end