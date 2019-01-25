note
	description: "Abstraction for source tree editing sub-application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-25 2:30:38 GMT (Friday 25th January 2019)"
	revision: "7"

deferred class
	SOURCE_TREE_EDITING_SUB_APPLICATION

inherit
	EL_REGRESSION_TESTABLE_SUB_APPLICATION

	EL_ARGUMENT_TO_ATTRIBUTE_SETTING
		undefine
			make, standard_options
		end

feature {NONE} -- Initialization

	normal_initialize
			--
		do
			if Is_test_mode then
				Console.show ({EL_REGRESSION_TESTING_ROUTINES})
			end
			set_defaults
			set_attribute_from_command_opt (tree_path, "source_tree", "Directory tree path")
		end

feature -- Basic operations

	normal_run
		local
			tree_processor: SOURCE_TREE_PROCESSOR
		do
			create tree_processor.make (tree_path, create {EDITING_COMMAND}.make (new_editor))
			tree_processor.do_all
		end

feature -- Testing	

	test_run
			--
		do
			across << "latin1-sources", "utf8-sources" >> as source loop
				Test.do_file_tree_test (source.item, agent test_source_tree, checksum [source.cursor_index])
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

	set_defaults
		do
			create tree_path
		end

	tree_path: EL_DIR_PATH

	new_editor: EL_EIFFEL_SOURCE_EDITOR
		deferred
		end

end
