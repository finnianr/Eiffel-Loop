note
	description: "Test class [$source PYXIS_TREE_TO_XML_COMPILER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 11:03:52 GMT (Monday 10th January 2022)"
	revision: "1"

class
	PYXIS_TREE_TO_XML_COMPILER_TEST_SET

inherit
	EL_COPIED_DIRECTORY_DATA_TEST_SET

	EIFFEL_LOOP_TEST_ROUTINES

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("compiler", agent test_compiler)
		end

feature -- Tests

	test_compiler
		local
			compiler: PYXIS_TREE_TO_XML_COMPILER; destination_path: FILE_PATH
			table, merged_table: EL_TRANSLATION_TABLE; root_node: EL_XPATH_ROOT_NODE_CONTEXT
			time_stamp: INTEGER
		do
			destination_path := work_area_data_dir.parent + "localization.xml"
			create compiler.make ("", work_area_data_dir, destination_path)
			compiler.execute
			create root_node.make_from_file (destination_path)
			create merged_table.make_from_root_node ("en", root_node)
			across OS.file_list (work_area_data_dir, "*.pyx") as path loop
				create table.make_from_pyxis ("en", path.item)
				across table as translation loop
					assert ("merged table has key", merged_table.has (translation.key))
				end
			end
			time_stamp := destination_path.modification_time
			compiler.execute
			assert ("file not changed", time_stamp = destination_path.modification_time)
		end

feature {NONE} -- Implementation

	source_dir: DIR_PATH
		do
			Result := EL_test_data_dir #+ "pyxis/localization"
		end

end