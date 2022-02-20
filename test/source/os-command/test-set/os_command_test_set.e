note
	description: "Os command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-20 12:20:16 GMT (Sunday 20th February 2022)"
	revision: "18"

class
	OS_COMMAND_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

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
		-- OS_COMMAND_TEST_SET.test_cpu_info
		local
			cpu_info_cmd: like Command.new_cpu_info; info_cmd: EL_CAPTURED_OS_COMMAND
			count: INTEGER; line: ZSTRING
		do
			if {PLATFORM}.is_unix then
				cpu_info_cmd := Command.new_cpu_info
				create info_cmd.make_with_name ("cat_cpuinfo", "cat /proc/cpuinfo")
				info_cmd.execute
				across info_cmd.lines as list until count = 2 loop
					line := list.item
					if line.starts_with_general ("model name") then
						assert ("has model name", line.has_substring (cpu_info_cmd.model_name))
						count := count + 1
					elseif line.starts_with_general ("siblings") then
						assert ("has siblings", line.ends_with_general (cpu_info_cmd.siblings.out))
						count := count + 1
					end
				end
				assert ("two fields", count = 2)
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