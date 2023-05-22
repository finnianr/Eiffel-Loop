note
	description: "OS command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-22 15:26:52 GMT (Monday 22nd May 2023)"
	revision: "26"

class
	OS_COMMAND_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EL_MODULE_SYSTEM

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["cpu_info",			  agent test_cpu_info],
				["create_tar_command", agent test_create_tar_command],
				["file_md5_sum",		  agent test_file_md5_sum],
				["user_list",			  agent test_user_list]
			>>)
		end

feature -- Tests

	test_cpu_info
		-- OS_COMMAND_TEST_SET.test_cpu_info
		local
			cpu_info: EL_CPU_INFO_COMMAND_I; info_cmd: EL_CAPTURED_OS_COMMAND
			count: INTEGER; line: ZSTRING; field: TUPLE [model_name, processors: ZSTRING]
		do
			create {EL_CPU_INFO_COMMAND_IMP} cpu_info.make
			field := cpu_info.field
			create info_cmd.make_with_name ("info_cmd", cpu_info.template)
			info_cmd.execute

			across info_cmd.lines as list until count = 2 loop
				line := list.item
				if line.starts_with_general (field.model_name) then
					assert ("has model name", line.has_substring (cpu_info.model_name))
					count := count + 1
				elseif line.starts_with_general (field.processors) then
					assert ("has processor_count", line.ends_with_general (cpu_info.processor_count.out))
					count := count + 1
				end
			end
			assert ("two fields", count = 2)
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
			assert ("modification_time is 0", tar_path.modification_time = 0)
			cmd.set_archive_path (tar_path)
			cmd.set_target_dir (work_area_data_dir)
			cmd.execute
			assert ("created", tar_path.exists)
		end

	test_file_md5_sum
		do
			if {PLATFORM}.is_unix and then attached file_path ("help-files.txt") as help_path
				and then attached OS.file_md5_digest (help_path).as_upper as str
			then
				lio.put_labeled_string (help_path.base, str)
				lio.put_new_line
				assert_same_string (Void, Digest.md5_plain_text (help_path).to_hex_string, str)
			end
		end

	test_user_list
		note
			testing: "covers/{EL_USERS_INFO_COMMAND_IMP}.make, covers/{EL_SYSTEM_ROUTINES_I}.user_permutation_list"
		local
			dir_path: DIR_PATH; steps: EL_PATH_STEPS; index: INTEGER
		do
			if attached OS.find_directories_command (Directory.home.parent) as cmd then
				cmd.set_depth (1 |..| 1)
				cmd.set_predicate_filter (agent is_user_directory)
				cmd.execute
				across cmd.path_list as list loop
					lio.put_path_field ("%S", list.item)
					lio.put_new_line
					assert ("path exists", list.item.exists)
				end
			end
			lio.put_new_line

			if attached System.user_permutation_list (Directory.app_all_list) as permutation_list then
				assert ("valid count", permutation_list.count = Directory.app_all_list.count * System.user_list.count)
				index := Directory.Users.step_count
				across permutation_list as list loop
					lio.put_path_field ("%S", list.item)
					lio.put_new_line
					steps := list.item.steps
					steps.keep_head (index)
					assert ("directory exists", steps.to_dir_path.exists)
				end
			end
		end

feature {NONE} -- Implementation

	is_user_directory (path: ZSTRING): BOOLEAN
		local
			dir_path: DIR_PATH
		do
			dir_path := path
			Result := System.user_list.has (dir_path.base)
		end

	source_dir: DIR_PATH
		do
			Result := Dev_environ.EL_test_data_dir #+ "txt"
		end

end