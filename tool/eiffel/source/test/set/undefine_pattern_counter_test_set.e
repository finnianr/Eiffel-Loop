note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-12 22:33:02 GMT (Friday 12th January 2024)"
	revision: "24"

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

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["command", agent test_command]
			>>)
		end

feature -- Tests

	test_command
		local
			command: UNDEFINE_PATTERN_COUNTER_COMMAND; expected_count: INTEGER
		do
			create command.make (Manifest_path)
			command.execute
			if attached command.greater_than_0_list as list then
				assert ("3 in list", list.count = 3)
				from list.start until list.after loop
					inspect list.index
						when 3 then
							expected_count := 2
					else
						expected_count := 1
					end
					assert ("expected number", list.item_value = expected_count)
					assert ("matches type",
						some_type_matches (<< {EL_SETTABLE_FROM_STRING}, {EL_PATH}, {EL_PATH_STEPS} >>, list.item_key)
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
			create Result.make_empty
			across << "kernel/reflection/settable", "runtime/file/naming" >> as path loop
				Result.append (OS.file_list (Data_dir #+ path.item, "*.e"))
			end
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "library/base"
		end
end