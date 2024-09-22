note
	description: "Undefine pattern counter test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 16:57:25 GMT (Sunday 22nd September 2024)"
	revision: "27"

class
	UNDEFINE_PATTERN_COUNTER_TEST_SET

inherit
	COPIED_SOURCES_TEST_SET
		undefine
			new_lio
		redefine
			Sources_sub_dir
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
			command: UNDEFINE_PATTERN_COUNTER_COMMAND
		do
			create command.make (Manifest_path)
			command.execute
			if attached command.greater_than_0_list as list then
				assert ("2 in list", list.count = 2)
				from list.start until list.after loop
					if Standard_undefines_table.has_key (to_class_name (list.item_key)) then
						assert ("expected number", list.item_value = Standard_undefines_table.found_item)
					else
						failed ("matches type")
					end
					list.forth
				end
			end
		end

feature {NONE} -- Implementation

	to_class_name (file_name: ZSTRING): STRING
		do
			Result := file_name
			Result.to_upper
			Result.remove_tail (2) -- .e
		end

feature {NONE} -- Constants

	Sources_sub_dir: DIR_PATH
		once
			Result := "utf-8"
		end

	Standard_undefines_table: EL_HASH_TABLE [INTEGER, STRING]
		once
			create Result.make_assignments (<<
				["TEST_EL_ASTRING", 1],
				["EL_TEXT_ITEM_TRANSLATIONS_TABLE", 6]
			>>)
		end

end