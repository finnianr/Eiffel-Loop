note
	description: "Development environment for Eiffel-Loop libraries"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-05-04 21:05:01 GMT (Sunday 4th May 2025)"
	revision: "5"

frozen class
	DEVELOPMENT_ENVIRONMENT

inherit
	ANY

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY; EL_MODULE_TUPLE

feature -- Basic operations

	put_eiffel_loop
		do
			if not attached Execution.item (Var_EIFFEL_LOOP) then
				Execution.put (Eiffel_loop_dir, Var_EIFFEL_LOOP)
			end
		end

feature -- Directories

	Eiffel_dir: DIR_PATH
		once
			Result := new_environ_dir (Eiffel)
		end

	Eiffel_loop_dir: DIR_PATH
		once
			Result := new_environ_dir (Eiffel_loop)
			if not Result.exists then
				Result := Eiffel_dir.joined_dir_tuple (["library", Eiffel_loop])
			end
		end

feature -- Constants

	EL_build_info: EIFFEL_LOOP_BUILD_INFO
		once
			create Result
		end

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