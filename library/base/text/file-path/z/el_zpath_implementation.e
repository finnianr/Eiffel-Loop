note
	description: "Implementation routines for [$source EL_ZPATH]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-13 16:01:29 GMT (Sunday 13th February 2022)"
	revision: "2"

deferred class
	EL_ZPATH_IMPLEMENTATION

inherit
	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_ITERABLE; EL_MODULE_FILE_SYSTEM; EL_MODULE_FORMAT

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

	to_string: ZSTRING
		do
			Result := filled_list.joined (Separator)
		end

feature -- Measurement

	leading_backstep_count: INTEGER
		local
			i: INTEGER
		do
			from i := 1 until i > step_count loop
				if i_th (i) = Step_table.back_dir_token then
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

feature {NONE} -- Deferred implementation

	area: SPECIAL [INTEGER]
		deferred
		end

	i_th alias "[]" (index: INTEGER): INTEGER
		deferred
		end

	is_empty: BOOLEAN
		deferred
		end

	new_path (a_step_count: INTEGER): like Current
		deferred
		end

	step_count: INTEGER
		deferred
		end

feature {EL_ZPATH} -- Implementation

	base_part (i: INTEGER): ZSTRING
		local
			pos_dot: INTEGER
		do
			if attached internal_base as str then
				pos_dot := dot_index (str)
				if pos_dot > 0 then
					inspect i
						when 1 then
							Result := str.substring (1, pos_dot - 1)
						when 2 then
							Result := str.substring (pos_dot + 1, str.count)
					else
						Result := str.twin
					end
				else
					Result := str.twin
				end
			end
		end

	dot_index (str: ZSTRING): INTEGER
		-- index of last dot, 0 if none
		do
			Result := str.last_index_of ('.', str.count)
		end

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

	internal_base: ZSTRING
		do
			if is_empty then
				create Result.make_empty
			else
				Result := Step_table.to_step (i_th (step_count))
			end
		end

	variable_name (step: ZSTRING): STRING_32
		do
			Result := step
			Result.remove_head (1)
		end

feature {NONE} -- Constants

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

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

	Temporary_dir: EL_DIR_ZPATH
		once
			create Result
		end
end