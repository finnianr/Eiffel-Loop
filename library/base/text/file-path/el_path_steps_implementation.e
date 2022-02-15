note
	description: "Implementation routines for [$source EL_PATH_STEPS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 17:20:01 GMT (Tuesday 15th February 2022)"
	revision: "2"

deferred class
	EL_PATH_STEPS_IMPLEMENTATION

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_FILE_SYSTEM; EL_MODULE_ITERABLE
	EL_MODULE_REUSEABLE

	EL_PATH_CONSTANTS
		export
			{NONE} all
			{ANY} Separator
		end

	EL_PROTOCOL_CONSTANTS

	EL_ZSTRING_CONSTANTS

	STRING_HANDLER
		undefine
			copy, default_create, is_equal
		end

feature {NONE} -- Deferred

	append_to (str: EL_APPENDABLE_ZSTRING)
		deferred
		end

feature {NONE} -- Implementation

	empty_uri_path: like URI_path_string
		do
			Result := URI_path_string; Result.wipe_out
		end

	has_expansion_variable (a_path: ZSTRING): BOOLEAN
		-- a step contains what might be an expandable variable
		local
			pos_dollor: INTEGER
		do
			pos_dollor := a_path.index_of ('$', 1)
			Result := pos_dollor > 0 and then (pos_dollor = 1 or else a_path [pos_dollor - 1] = Separator)
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

	Temporary_dir: DIR_PATH
		once
			create Result
		end

	URI_path_string: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end

end