note
	description: "Eiffel loop test constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "15"

deferred class
	EIFFEL_LOOP_TEST_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	new_eiffel_loop_dir: DIR_PATH
		local
			steps: EL_PATH_STEPS
		do
			from
				steps := Directory.working
			until
				steps.is_empty or else steps.last ~ Eiffel_loop
			loop
				steps.remove_tail (1)
			end
			Result := steps
		end

feature {NONE} -- Constants

	EL_build_info: EIFFEL_LOOP_BUILD_INFO
		once
			create Result
		end

	EL_test_data_dir: DIR_PATH
			--
		once
			Result := Eiffel_loop_dir.joined_dir_tuple (["test/data"])
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