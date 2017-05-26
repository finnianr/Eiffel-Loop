note
	description: "[
		Count lines of eiffel code for combined source trees defined by a source tree manifest. 
		Lines are counted starting from the class keyword and exclude comments and blank lines.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-21 19:59:25 GMT (Sunday 21st May 2017)"
	revision: "3"

class
	EIFFEL_CODEBASE_STATISTICS_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [EIFFEL_CODEBASE_STATISTICS_COMMAND]
		redefine
			Option_name
		end

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("Eiffel/latin1-sources", agent test_note_edit, 1404346495)
			Test.do_file_tree_test ("Eiffel/utf8-sources", agent test_note_edit, 191337464)
		end

	test_note_edit (a_sources_path: EL_DIR_PATH)
			--
		do
			create command.make (a_sources_path + "manifest.pyx")
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_manifest_path: EL_FILE_PATH]
		do
			create Result
			Result.source_manifest_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
		do
			Result := <<
				required_existing_path_argument ("sources", "Path to sources manifest file")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "codebase_stats"

	Description: STRING = "[
		Count lines of eiffel code for combined source trees defined by a source tree manifest. 
		Lines are counted starting from the class keyword and exclude comments and blank lines.
	]"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_CODEBASE_STATISTICS_APP}, All_routines],
				[{EIFFEL_CODEBASE_STATISTICS_COMMAND}, All_routines]
			>>
		end

end
