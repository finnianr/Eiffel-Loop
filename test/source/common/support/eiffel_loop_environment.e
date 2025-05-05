note
	description: "Development environment for Eiffel-Loop libraries"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-05 9:32:09 GMT (Monday 5th May 2025)"
	revision: "6"

frozen class
	EIFFEL_LOOP_ENVIRONMENT

inherit
	ANY
		redefine
			default_create
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY; EL_MODULE_TUPLE

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			eiffel_dir := new_environ_dir (Eiffel)

			home_dir := new_environ_dir (Eiffel_loop)
			if not home_dir.exists then
				home_dir := eiffel_dir.joined_dir_tuple (["library", Eiffel_loop])
			end
			create build_info
		end

feature -- Basic operations

	set_environment
		-- set EIFFEL_LOOP environment label
		do
			if not attached Execution.item (Var_EIFFEL_LOOP) then
				Execution.put (home_dir, Var_EIFFEL_LOOP)
			end
		end

feature -- Directories

	eiffel_dir: DIR_PATH

	home_dir: DIR_PATH

feature -- Constants

	build_info: EIFFEL_LOOP_BUILD_INFO

	Eiffel: ZSTRING
		once
			Result := "Eiffel"
		end

	Eiffel_loop: ZSTRING
		once
			Result := "Eiffel-Loop"
		end

	Var_EIFFEL_LOOP: STRING = "EIFFEL_LOOP"

feature {NONE} -- Implementation

	new_environ_dir (step: ZSTRING): DIR_PATH
		local
			variable: ZSTRING
		do
			variable := step.as_upper
			variable.replace_character ('-', '_')
			if attached Execution.item (variable) as path then
				Result := path

			elseif Directory.working.has_step (step) then
				Result := Directory.working.twin
				Result.prune_until (step)
			else
				Result := step
			end
		end

end