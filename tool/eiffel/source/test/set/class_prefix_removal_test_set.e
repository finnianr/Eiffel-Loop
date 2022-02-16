note
	description: "[
		 Test editing class [$source CLASS_PREFIX_REMOVER]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-16 14:06:03 GMT (Wednesday 16th February 2022)"
	revision: "3"

class
	CLASS_PREFIX_REMOVAL_TEST_SET

inherit
	EDITOR_COMMAND_TEST_SET
		redefine
			adjusted_path, on_prepare
		end

feature {NONE} -- Event handling

	on_prepare
		do
			Precursor
			create class_prefix.make_empty
		end

feature {NONE} -- Implementation

	adjusted_path (file_path: FILE_PATH): FILE_PATH
		do
			if file_path.base.starts_with (class_prefix.as_lower) then
				Result := file_path.twin
				Result.set_base (Result.base.substring_end (class_prefix.count + 2))
			else
				Result := file_path
			end
		end

	new_edit (file_path: FILE_PATH): PROCEDURE
		local
			editor: CLASS_PREFIX_REMOVER
		do
			if file_path.base.starts_with_general ("job") then
				class_prefix := "JOB"
			else
				class_prefix := "EL"
			end
			create editor.make (class_prefix)
			editor.set_source_path (file_path)
			Result := agent editor.edit
		end

feature {NONE} -- Internal attributes

	class_prefix: ZSTRING

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, ZSTRING]
		once
			create Result.make_equal (11)
			Result [Name.copy_file_impl] := 857785050
			Result [Name.mp3_convert_command] := 301119923

--			Test insertions for: do_all (eval: EL_EQA_TEST_EVALUATOR)
--			and test correct BOM marker for UTF-8 encoding
			Result [Name.subject_line_decoder_test_set] := 2574402360

			Result [Name.job_duration_parser] := 1765686916
			Result [Name.subscription_delivery_email] := 2452859251

--			test frozen feature name sort
			Result [Name.id3_tag_frame_cpp_api] := 808972193
		end

end