note
	description: "Test class [$source FEATURE_EDITOR_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-09 14:54:54 GMT (Thursday 9th March 2023)"
	revision: "21"

class
	FEATURE_EDITOR_COMMAND_TEST_SET

inherit
	EDITOR_COMMAND_TEST_SET

feature {NONE} -- Implementation

	new_edit (file_path: FILE_PATH): PROCEDURE
		local
			command: FEATURE_EDITOR_COMMAND
		do
			create command.make (file_path, False)
			Result := agent command.execute
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, ZSTRING]
		once
			create Result.make_equal (11)
			Result [Name.copy_file_impl] := 4276247644
			Result [Name.mp3_convert_command] := 3362452

--			Test insertions for: do_all (eval: EL_TEST_SET_EVALUATOR)
--			and test correct BOM marker for UTF-8 encoding
			Result [Name.subject_line_decoder_test_set] := 2727929860

			Result [Name.job_duration_parser] := 2651641799
			Result [Name.subscription_delivery_email] := 1955610778

--			test frozen feature name sort
			Result [Name.id3_tag_frame_cpp_api] := 118099087

--			test clean-up of leading spaces after new-line
			Result [Name.pixmap_imp_drawable] := 1395307592
		end

end