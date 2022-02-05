note
	description: "Test class [$source FEATURE_EDITOR_COMMAND]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 8:48:13 GMT (Saturday 5th February 2022)"
	revision: "16"

class
	FEATURE_EDITOR_COMMAND_TEST_SET

inherit
	EDITOR_COMMAND_TEST_SET

feature {NONE} -- Implementation

	new_edit (file_path: FILE_PATH): PROCEDURE
		local
			command: FEATURE_EDITOR_COMMAND
		do
			create command.make (file_path)
			Result := agent command.execute
		end

feature {NONE} -- Constants

	Checksum_table: EL_HASH_TABLE [NATURAL, ZSTRING]
		once
			create Result.make_equal (11)
			Result [File.copy_file_impl] := 3882863469
			Result [File.mp3_convert_command] := 3362452

--			Test insertions for: do_all (eval: EL_EQA_TEST_EVALUATOR)
--			and test correct BOM marker for UTF-8 encoding
			Result [File.subject_line_decoder_test_set] := 323797391

			Result [File.job_duration_parser] := 2651641799
			Result [File.subscription_delivery_email] := 1955610778

--			test frozen feature name sort
			Result [File.id3_tag_frame_cpp_api] := 118099087
		end


end