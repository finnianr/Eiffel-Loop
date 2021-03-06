note
	description: "Find and replace operating on a source manifest file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-10 10:07:52 GMT (Tuesday 10th November 2020)"
	revision: "13"

class
	FIND_AND_REPLACE_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [FIND_AND_REPLACE_COMMAND]
		rename
			extra_log_filter_set as empty_log_filter_set
		redefine
			Option_name
		end

feature -- Testing

	test_run
			--
		do
			-- Test will always fail because of date stamp written to files (different CRC)
			Test.do_file_tree_test ("latin1-sources", agent test_find_replace (?, " is", " -- is"), 3042838246)
			Test.do_file_tree_test ("utf8-sources", agent test_find_replace (?, " is", " -- is"), 3042838246)
		end

	test_find_replace (a_sources_path: EL_DIR_PATH; find_text, replacement_text: STRING)
			--
		do
			create command.make (a_sources_path + "manifest.pyx", find_text, replacement_text)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("sources", "Path to sources manifest file", << file_must_exist >>),
				required_argument ("find", "Text to find in source files"),
				required_argument ("replace", "Replacement text")
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("", "", "")
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 0

	Option_name: STRING = "find_replace"

	Description: STRING = "Finds and replaces text in Eiffel source files"

end