note
	description: "Eiffel loop test constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-13 10:47:57 GMT (Thursday 13th February 2020)"
	revision: "12"

deferred class
	EIFFEL_LOOP_TEST_CONSTANTS

inherit
	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

feature {NONE} -- Constants

	EL_build_info: EIFFEL_LOOP_BUILD_INFO
		once
			create Result
		end

	EL_test_data_dir: EL_DIR_PATH
			--
		once
			Result := Eiffel_loop_dir.joined_dir_tuple (["test/data"])
		end

	Eiffel_loop: ZSTRING
		once
			Result := "Eiffel-Loop"
		end

	Eiffel_loop_dir: EL_DIR_PATH
		local
			steps: EL_PATH_STEPS
		once
			Result := Execution.variable_dir_path ("EIFFEL_LOOP")
			if Result.is_empty then
				from
					steps := Directory.current_working
				until
					steps.is_empty or else steps.last ~ Eiffel_loop
				loop
					steps.remove_tail (1)
				end
				Result := steps
			end
		end

end
