note
	description: "Test class [$source _TREE_INPUT_OUTPUT_COMMAND_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-11 9:12:32 GMT (Tuesday 11th September 2018)"
	revision: "1"

class
	FILE_TREE_INPUT_OUTPUT_COMMAND_TEST_SET

inherit
	HELP_PAGES_TEST_SET

feature -- Tests

	test_copy_file_command
		local
			transformer: EL_FILE_TREE_TRANSFORMER
			copy_cmd: FILE_COPY_COMMAND; input_dir, output_dir: EL_DIR_PATH
		do
			create copy_cmd.make
			input_dir := Work_area_dir.joined_dir_path (Help_pages)
			output_dir := input_dir.twin
			output_dir.base.append_string_general (" (copy)")

			create transformer.make (input_dir, output_dir, "txt")
			transformer.apply (copy_cmd)
			assert ("Files match", across OS.file_list (input_dir, "*.txt") as path all
				(output_dir + path.item.relative_path (input_dir)).exists
			end)
		end

end
