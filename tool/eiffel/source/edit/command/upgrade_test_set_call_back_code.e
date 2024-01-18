note
	description: "[
		Upgrade ${EL_EQA_TEST_SET} descendants to use new initialization method for naming
		test routines instead of using call-backs.
	]"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 6:16:34 GMT (Thursday 17th August 2023)"
	revision: "7"

class
	UPGRADE_TEST_SET_CALL_BACK_CODE

obsolete
	"Once-off use"

inherit
	SOURCE_MANIFEST_COMMAND
		redefine
			make_default, new_file_list
		end

	EL_MODULE_FILE; EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			create feature_block_split.make_empty
		end

feature -- Access

	Description: STRING = "Upgrade code for naming test routine agents in EQA test sets"

feature {NONE} -- Implementation

	do_with_file (source_path: FILE_PATH)
		local
			source_text, old_code: STRING; found: BOOLEAN
			start_index, end_index: INTEGER
		do
			source_text := File.plain_text (source_path)
			across 1 |..| 2 as scan loop
				feature_block_split.fill_by_string (source_text, Feature_marker, 0)
				if attached feature_block_split as list then
					if scan.cursor_index = 1 then
						from list.start until found or else list.after loop
							if list.item_has_substring (Code.evaluator_arg) then
								start_index := list.item_lower; end_index := list.item_upper
								old_code := source_text.substring (start_index, end_index)
								source_text.replace_substring (new_make_routine_code (old_code), start_index, end_index)
								found := True
							end
							list.forth
						end
					elseif found then
--						insert "create make" before first feature block if class is not deferred
						list.start
						if not list.item_has_substring ("deferred class") then
							end_index := list.item_upper
							source_text.insert_string ("%N%Ncreate%N%Tmake", list.item_upper)
						end
					end
				end
			end
			if found then
				File.write_text (source_path, source_text)
			end
		end

	new_file_list: EL_FILE_PATH_LIST
		do
			create Result.make_from_if (manifest.file_list, agent is_test_set)
		end

	new_make_routine_code (old_code: STRING): STRING
		local
			code_lines: EL_STRING_8_LIST; line: STRING; editing_routine: BOOLEAN
			do_line_index, end_line_index, index: INTEGER;
		do
			create code_lines.make_with_lines (old_code)
			across code_lines as list until end_line_index > 0 loop
				line := list.item
				line.right_adjust
				if line.has_substring (Code.basic_ops) then
					line.share (" {NONE} -- Initialization")

				elseif line.has_substring (Code.evaluator_arg) then
					line.replace_substring ("make", 2, line.count)
					editing_routine := True

				elseif editing_routine then
					if line.has_substring (Code.evaluate_comment) then
						index := line.substring_index (Code.evaluate_comment, 1)
						line.replace_substring ("initialize `test_table'", index + 3, line.count)

					elseif line.ends_with (Code.do_) then
						do_line_index := list.cursor_index

					elseif line.has_substring (Code.eval_call) then
						index := line.substring_index (Code.eval_call, 1)
						line.replace_substring ("%T[", index, line.index_of ('"', 1) - 1)
						line.replace_substring ("],", line.count, line.count)

					elseif line.ends_with (Code.end_) then
						end_line_index := list.cursor_index
					end
				end
			end
			code_lines [end_line_index - 1].prune_all_trailing (',')
			code_lines.insert (tab * 3 + Code.close_array, end_line_index)
			code_lines.insert (tab * 3 + Code.make_named, do_line_index + 1)

			Result := code_lines.joined_lines
		end

	is_test_set (file_path: FILE_PATH): BOOLEAN
		do
			Result := file_path.base.ends_with (Test_set_ending)
		end

feature {NONE} -- Internal attributes

	feature_block_split: EL_SPLIT_STRING_8_LIST

feature {NONE} -- Constants

	Code: TUPLE [do_, end_, eval_call, evaluator_arg, evaluate_comment, basic_ops, make_named, close_array: STRING]
		once
			create Result
			Tuple.fill (Result,
				"do, end, eval.call, eval: EL_TEST_SET_EVALUATOR, -- evaluate, Basic operations, make_named (<<, >>)"
			)
		end

	Feature_marker: STRING = "%Nfeature"

	Test_set_ending: ZSTRING
		once
			Result := "_test_set.e"
		end

note
	notes: "[
		Old call-back code:

			feature -- Basic operations

				do_all (eval: EL_TEST_SET_EVALUATOR)
					-- evaluate all tests
					do
						eval.call ("iso",		agent test_iso)
						eval.call ("utf_8",	agent test_utf_8)
					end

		New make routine code:

			feature {NONE} -- Initialization

				make
					do
						make_named (<<
							["iso",		agent test_iso],
							["utf_8",	agent test_utf_8]
						>>
					end

	]"

end