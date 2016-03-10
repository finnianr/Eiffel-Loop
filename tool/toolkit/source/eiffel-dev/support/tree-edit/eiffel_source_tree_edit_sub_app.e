note
	description: "Summary description for {EIFFEL_SOURCE_EDIT_SUB_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "4"

deferred class
	EIFFEL_SOURCE_TREE_EDIT_SUB_APP

inherit
	FILE_TREE_OPERATING_SUB_APP

feature {NONE} -- Initialization

	normal_run
		local
			tree_processor: EIFFEL_SOURCE_TREE_PROCESSOR
		do
			create tree_processor.make (tree_path, create_file_editor)
			tree_processor.do_all
		end

feature -- Testing	

	test_run
			--
		do
			Test.do_file_tree_test ("sample-source", agent test_source_tree, checksum)
		end

	test_source_tree (dir_path: EL_DIR_PATH)
		do
			set_defaults
			tree_path := dir_path
			normal_initialize
			normal_run
		end

	checksum: NATURAL
		deferred
		end

feature {NONE} -- Implementation

	create_file_editor: EIFFEL_SOURCE_EDITING_PROCESSOR
		deferred
		end

end
