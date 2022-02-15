note
	description: "Eiffel loop test constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 10:49:51 GMT (Tuesday 15th February 2022)"
	revision: "18"

deferred class
	EIFFEL_LOOP_TEST_ROUTINES

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	set_eiffel_loop_env
		do
			if not attached Execution.item (Var_EIFFEL_LOOP) then
				Execution.put (new_eiffel_loop_dir, Var_EIFFEL_LOOP)
			end
		end

	new_eiffel_loop_dir: DIR_PATH
		local
			l_working: DIR_PATH
		do
			l_working := Directory.working.twin
			l_working.prune_until (Eiffel_loop)
			Result := l_working
		end

feature {NONE} -- Constants

	EL_build_info: EIFFEL_LOOP_BUILD_INFO
		once
			create Result
		end

	EL_test_data_dir: DIR_PATH
			--
		once
			Result := Eiffel_loop_dir #+ "test/data"
		end

	Eiffel_loop: ZSTRING
		once
			Result := "Eiffel-Loop"
		end

	Eiffel_loop_dir: DIR_PATH
		once
			if attached Execution.item (Var_EIFFEL_LOOP) as path then
				Result := path
			else
				Result := new_eiffel_loop_dir
			end
		end

	Var_EIFFEL_LOOP: STRING = "EIFFEL_LOOP"
end