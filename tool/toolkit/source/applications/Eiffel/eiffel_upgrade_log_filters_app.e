note
	description: "Upgrade syntax of Eiffel Loop logging filter arrays"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

class
	EIFFEL_UPGRADE_LOG_FILTERS_APP

inherit
	EIFFEL_SOURCE_TREE_EDIT_SUB_APP
		redefine
			Option_name, test_run
		end

create
	make

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_LOG_FILTER_ARRAY_SOURCE_EDITOR
		do
			create Result.make
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("sample-source/sub_applications", agent test_source_tree, checksum)
		end

feature {NONE} -- Constants

	Checksum: NATURAL = 355826088

	Option_name: STRING = "log_upgrade"

	Description: STRING = "Comment out logging lines from Eiffel source code tree"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_UPGRADE_LOG_FILTERS_APP}, "*"],
				[{EIFFEL_SOURCE_TREE_PROCESSOR}, "*"],
				[{EL_TEST_ROUTINES}, "*"]
			>>
		end

end
