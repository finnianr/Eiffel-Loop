note
	description: "[
		Expands Eiffel shorthand code. See class `EIFFEL_FEATURE_EDITOR_COMMAND'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 9:36:22 GMT (Wednesday 22nd June 2016)"
	revision: "6"

class
	EIFFEL_FEATURE_EDITOR_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [EIFFEL_FEATURE_EDITOR_COMMAND]
		redefine
			Option_name
		end

feature -- Testing

	test_run
			-- Passed Jan 2016
		do
--			Test.do_file_test ("Eiffel/feature-edits/job_duration_parser.e", agent test_file_edit, 2770358171)
--			Test.do_file_test ("Eiffel/feature-edits/el_mp3_convert_command.e", agent test_file_edit, 1765953481)
			Test.do_file_test ("Eiffel/feature-edits/el_copy_file_impl.e", agent test_file_edit, 1693063132)
--			Test.do_file_test ("Eiffel/feature-edits/subscription_delivery_email.e", agent test_file_edit, 1599303034)
		end

	test_file_edit (a_source_path: EL_FILE_PATH)
			--
		do
			create command.make (a_source_path)
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_path: EL_FILE_PATH]
		do
			create Result
			Result.source_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("source", "Source file path")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "feature_edit"

	Description: STRING = "[
		Edits an Eiffel class by expanding feature abbreviations: @f {xx OR @f xx
		where xx is a 2 letter code for a common feature label. The { character is 
		expanded as {NONE}. Also reorders features alphabetically
	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EL_TEST_ROUTINES}, "*"],
				[{EIFFEL_FEATURE_EDITOR_APP}, "*"],
				[{EIFFEL_FEATURE_EDITOR_COMMAND}, "*"]
			>>
		end

end
