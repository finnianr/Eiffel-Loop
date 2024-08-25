note
	description: "Implementation routines for ${EL_PATH_STEPS}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:15:19 GMT (Sunday 25th August 2024)"
	revision: "9"

deferred class
	EL_PATH_STEPS_IMPLEMENTATION

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE_SYSTEM; EL_MODULE_ITERABLE

	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	EL_PATH_BUFFER_ROUTINES

	EL_PROTOCOL_CONSTANTS

	EL_SHARED_STRING_32_BUFFER_SCOPES

feature -- Access

	first_token: INTEGER
		require
			has_first: count > 0
		do
			Result := area [0]
		end

	last_token: INTEGER
		require
			has_last: count > 0
		do
			Result := area [count - 1]
		end

feature -- Measurement

	count: INTEGER
		do
			Result := area.count
		end

feature -- Element change

	put_token_front (token: INTEGER)
		do
			if attached token_list as list then
				list.put_front (token)
				area := list.area
			end
			internal_hash_code := 0
		end

feature -- Status report

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' a valid index?
		do
			Result := (1 <= i) and (i <= count)
		end

feature {EL_PATH_STEPS_IMPLEMENTATION} -- Implementation

	append (a_steps: EL_PATH_STEPS_IMPLEMENTATION)
			-- Append a copy of `s'.
		local
			c, old_count, new_count: INTEGER
		do
			c := a_steps.count
				-- If `s' is empty nothing to be done.
			if c > 0 then
				old_count := count
				new_count := old_count + a_steps.count
				if new_count > area.capacity then
					area := area.aliased_resized_area (new_count)
				end
				area.copy_data (a_steps.area, 0, old_count, c)
			end
		end

	extend_token (token: INTEGER_32)
			-- Replace `i'-th entry, if in index interval, by `token'.
		do
			if attached token_list as list then
				list.extend (token)
				area := list.area
			end
			internal_hash_code := 0
		end

	i_th_token (i: INTEGER): INTEGER
			-- Item at `i'-th position
		do
			Result := area.item (i - 1)
		end

	put_i_th_token (token: like i_th_token; i: INTEGER_32)
			-- Replace `i'-th entry, if in index interval, by `token'.
		do
			area.put (token, i - 1)
		end

feature {NONE} -- Implementation

	empty_uri_path: like URI_path_string
		do
			Result := URI_path_string; Result.wipe_out
		end

	has (token: INTEGER): BOOLEAN
			-- Does current include `token'?
			-- (Reference or object equality,
			-- based on `object_comparison'.)
		local
			l_area: like area
			i, nb: INTEGER
		do
			l_area := area
			nb := count - 1
			from until i > nb or Result loop
				Result := token = l_area.item (i)
				i := i + 1
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

	token_list: EL_STEP_TOKEN_LIST
		do
			Result := Shared_token_list
			Result.set_area (area)
		end

	variable_name (step: ZSTRING): STRING_32
		do
			Result := step
			Result.remove_head (1)
		end

feature {EL_PATH_STEPS_IMPLEMENTATION} -- Internal attributes

	area: SPECIAL [INTEGER]

	internal_hash_code: INTEGER

feature {NONE} -- Constants

	Shared_token_list: EL_STEP_TOKEN_LIST
		once
			create Result.make (0)
		end

	Step_list: EL_ZSTRING_LIST
		once
			create Result.make (0)
		end

	Step_table: EL_PATH_STEP_TABLE
		once ("PROCESS")
			create Result.make
		end

	Temporary_dir: DIR_PATH
		once
			create Result
		end

end