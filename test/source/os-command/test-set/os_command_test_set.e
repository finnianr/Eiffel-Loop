note
	description: "Os command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-06 13:11:43 GMT (Thursday 6th January 2022)"
	revision: "16"

class
	OS_COMMAND_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_CONSTANTS

	EL_MODULE_COMMAND

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("cpu_info", agent test_cpu_info)
			eval.call ("create_tar_command", agent test_create_tar_command)
		end

feature -- Tests

	test_cpu_info
		local
			cpu_info_cmd: like Command.new_cpu_info; info_cmd: EL_CAPTURED_OS_COMMAND
		do
			if {PLATFORM}.is_unix then
				cpu_info_cmd := Command.new_cpu_info
				create info_cmd.make_with_name ("cat_cpuinfo", "cat /proc/cpuinfo | grep %"$model_name%" --max-count 1")
				info_cmd.put_string ("model_name", cpu_info_cmd.model_name)
				info_cmd.execute
				assert ("begins with model name", info_cmd.lines.first.starts_with_general ("model name"))
			end
		end

	test_create_tar_command
		note
			testing: "covers/{EL_PARSED_OS_COMMAND}.make, covers/{EL_PARSED_OS_COMMAND}.valid_variable_names"
		local
			cmd: EL_CREATE_TAR_COMMAND
			tar_path: FILE_PATH
		do
			create cmd.make
			tar_path := Work_area_dir + "archive.tar"
			cmd.set_archive_path (tar_path)
			cmd.set_target_dir (work_area_data_dir)
			cmd.execute
			assert ("created", tar_path.exists)
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := EL_test_data_dir #+ "txt"
		end

end