note
	description: "Protein folding test set"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-20 15:31:29 GMT (Sunday 20th February 2022)"
	revision: "3"

class
	PROTEIN_FOLDING_TEST_SET

inherit
	EL_COPIED_FILE_DATA_TEST_SET
		undefine
			new_lio
		end

	EL_CRC_32_TEST_ROUTINES

	EL_COMMAND_CLIENT undefine default_create end

	EL_MODULE_EIFFEL

feature -- Basic operations

	do_all (evaluator: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			evaluator.call ("multi_core_2_1_with_grid_2_5", agent test_multi_core_2_1_with_grid_2_5)
			evaluator.call ("one_core_1_0", agent test_one_core_1_0)
			evaluator.call ("one_core_2_0_with_grid_2_2", agent test_one_core_2_0_with_grid_2_2)
			evaluator.call ("one_core_2_0_with_grid_2_3", agent test_one_core_2_0_with_grid_2_3)
			evaluator.call ("one_core_2_0_with_grid_2_4", agent test_one_core_2_0_with_grid_2_4)
			evaluator.call ("one_core_2_0_with_grid_2_5", agent test_one_core_2_0_with_grid_2_5)
			evaluator.call ("one_core_2_0_with_grid_2_6", agent test_one_core_2_0_with_grid_2_6)
			evaluator.call ("one_core_2_0_with_grid_2_7", agent test_one_core_2_0_with_grid_2_7)
		end

feature -- Tests

	test_multi_core_2_1_with_grid_2_5
		do
			do_test ("solve_for_each_file", 2021610886, agent solve_for_each_file, [{MULTI_CORE_PF_COMMAND_2_1 [GRID_2_5]}])
		end

	test_one_core_1_0
		do
			do_test ("solve_for_each_file", 0, agent solve_for_each_file, [{PF_COMMAND_1_0}])
		end

	test_one_core_2_0_with_grid_2_2
		do
			do_test ("solve_for_each_file", 0, agent solve_for_each_file, [{PF_COMMAND_2_0 [GRID_2_2]}])
		end

	test_one_core_2_0_with_grid_2_3
		do
			do_test ("solve_for_each_file", 0, agent solve_for_each_file, [{PF_COMMAND_2_0 [GRID_2_3]}])
		end

	test_one_core_2_0_with_grid_2_4
		do
			do_test ("solve_for_each_file", 0, agent solve_for_each_file, [{PF_COMMAND_2_0 [GRID_2_4]}])
		end

	test_one_core_2_0_with_grid_2_5
		-- PROTEIN_FOLDING_TEST_SET.test_one_core_2_0_with_grid_2_5
		do
			do_test ("solve_for_each_file", 493908621, agent solve_for_each_file, [{PF_COMMAND_2_0 [GRID_2_5]}])
		end

	test_one_core_2_0_with_grid_2_6
		do
			do_test ("solve_for_each_file", 0, agent solve_for_each_file, [{PF_COMMAND_2_0 [GRID_2_6]}])
		end

	test_one_core_2_0_with_grid_2_7
		do
			do_test ("solve_for_each_file", 0, agent solve_for_each_file, [{PF_COMMAND_2_0 [GRID_2_7]}])
		end

feature {NONE} -- Implementation

	input_sequence (result_path: FILE_PATH): STRING
		do
			Result := result_path.base_sans_extension
		end

	output_path (result_path: FILE_PATH): FILE_PATH
		do
			Result := Work_area_dir + (Folds_prefix + result_path.base)
		end

	solve_for_each_file (command_type: TYPE [PROTEIN_FOLDING_COMMAND])
		-- solve and compare with 5 precomputed result files named by input sequence
		local
			result_path: FILE_PATH; result_digest: STRING
		do
			across file_list as list loop
				result_path := list.item
				if attached {PROTEIN_FOLDING_COMMAND} Eiffel.new_object (command_type) as command then
					if attached {MULTI_CORE_PF_COMMAND [ANY]} command as multicore then
						multicore.make (input_sequence (result_path), output_path (result_path), 50)
					else
						command.make (input_sequence (result_path), output_path (result_path))
					end
					command.execute
					result_digest := Digest.md5_plain_text (result_path).to_base_64_string
					assert_same_digest (command.output_path, result_digest)
				end
			end
		end

	source_file_list: EL_FILE_PATH_LIST
		do
			Result := OS.file_list (Data_dir, "*.txt")
		end

feature {NONE} -- Constants

	Data_dir: DIR_PATH
		once
			Result := "test-data/pf_hp"
		end

	Folds_prefix: ZSTRING
		once
			Result := "folds-"
		end

end

