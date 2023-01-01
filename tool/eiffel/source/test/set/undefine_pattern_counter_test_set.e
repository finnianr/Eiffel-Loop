note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 11:34:29 GMT (Sunday 1st January 2023)"
	revision: "20"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		undefine
			new_lio
		redefine
			source_file_list
		end

	EL_CRC_32_TESTABLE

	EL_MODULE_DIRECTORY; EL_MODULE_EXECUTION_ENVIRONMENT

	SHARED_DEV_ENVIRON

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("command", agent test_command)
		end

feature -- Tests

	test_command
		local
			command: UNDEFINE_PATTERN_COUNTER_COMMAND
		do
			create command.make (Manifest_path, create {EL_DIR_PATH_ENVIRON_VARIABLE})
			command.execute
			if attached command.greater_than_0_list as list then
				assert ("1 in list", list.count = 1)
				from list.start until list.after loop
					assert ("2 patterns found", list.item_value = 2)
					assert ("matches type",
						some_type_matches (<< {EL_SETTABLE_FROM_STRING}, {EL_PATH} >>, list.item_key)
					)
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	some_type_matches (type_list: ARRAY [TYPE [ANY]]; file_name: ZSTRING): BOOLEAN
		local
			src_name: ZSTRING
		do
			across type_list as type until Result loop
				create src_name.make_from_general (type.item.name)
				src_name.to_lower
				src_name.append_string_general (".e")
				Result := src_name ~ file_name
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir #+ "kernel/reflection/settable", "*.e")
			Result.append (OS.file_list (Data_dir #+ "text/file/naming", "*.e"))
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "library/base"
		end
end