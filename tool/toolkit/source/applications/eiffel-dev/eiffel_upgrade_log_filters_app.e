note
	description: "Upgrade syntax of Eiffel Loop logging filter arrays"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 10:41:42 GMT (Thursday 4th August 2016)"
	revision: "2"

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

	new_editor: EIFFEL_LOG_FILTER_ARRAY_SOURCE_EDITOR
		do
			create Result.make
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("Eiffel/latin1-sources/sub_applications", agent test_source_tree, checksum [1])
		end

feature {NONE} -- Constants

	Checksum: ARRAY [NATURAL]
			-- 4 Aug 2016
		once
			Result := << 1767075359, 0 >>
		end

	Option_name: STRING = "log_upgrade"

	Description: STRING = "Change class names in {EL_SUB_APPLICATION}.Log_filter from strings to class types"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{EIFFEL_UPGRADE_LOG_FILTERS_APP}, All_routines]
			>>
		end

end
