note
	description: "Test suite for class [$source EL_FILE_TREE_TRANSFORMER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:51:50 GMT (Monday 3rd January 2022)"
	revision: "6"

class
	FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET

inherit
	HELP_PAGES_TEST_SET

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("copy_file_command", agent test_copy_file_command)
		end

feature -- Tests

	test_copy_file_command
		local
			transformer: EL_FILE_TREE_TRANSFORMER
			copy_cmd: FILE_COPY_COMMAND; input_dir, output_dir: DIR_PATH
		do
			create copy_cmd.make
			input_dir := Workarea_help_pages_dir
			output_dir := input_dir.twin
			output_dir.base.append_string_general (" (copy)")

			create transformer.make (input_dir, output_dir, "txt")
			transformer.apply (copy_cmd)
			assert ("Files match",
				across OS.file_list (input_dir, "*.txt") as path all
					(output_dir + path.item.relative_path (input_dir)).exists
				end
			)
		end

end