note
	description: "Summary description for {EIFFEL_SOURCE_EDIT_SUB_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-04 9:43:20 GMT (Thursday 4th August 2016)"
	revision: "2"

deferred class
	EIFFEL_SOURCE_TREE_EDIT_SUB_APP

inherit
	FILE_TREE_OPERATING_SUB_APP

feature {NONE} -- Initialization

	normal_run
		local
			tree_processor: EIFFEL_SOURCE_TREE_PROCESSOR
		do
			create tree_processor.make (tree_path, create {EIFFEL_EDITING_COMMAND}.make (new_editor))
			tree_processor.do_all
		end

feature -- Testing	

	test_run
			--
		do
			across << "latin1-sources", "utf8-sources" >> as source loop
				Test.do_file_tree_test ("Eiffel/" + source.item, agent test_source_tree, checksum [source.cursor_index])
			end
		end

	test_source_tree (dir_path: EL_DIR_PATH)
		do
			set_defaults
			tree_path := dir_path
			normal_initialize
			normal_run
		end

	checksum: ARRAY [NATURAL]
		deferred
		end

feature {NONE} -- Implementation

	new_editor: EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

end
