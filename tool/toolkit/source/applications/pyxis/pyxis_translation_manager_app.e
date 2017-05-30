note
	description: "Perform queries and/or edits on tree of Pyxis localization files"

	instructions: "[
		**Command line**
		
			el_toolkit -manage_translation [-edit <edit command>] [-query <query command>]
			
		**Edit Commands**
		
		`add_check_attribute' adds a check attribute after every field `lang = <language>', for example
		`lang = de; check = false'

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:20:10 GMT (Monday 29th May 2017)"
	revision: "3"

class
	PYXIS_TRANSLATION_MANAGER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [PYXIS_TRANSLATION_MANAGER]
		redefine
			Option_name
		end

create
	make

feature -- Testing

	test_run
			--
		do
			Test.do_file_tree_test ("pyxis/localization", agent test_add_check_attribute, 3357932840)
		end

	test_add_check_attribute (source_tree_path: EL_DIR_PATH)
		do
			create {PYXIS_TRANSLATION_MANAGER} command.make (source_tree_path, "", "add_check_attribute")
			normal_run
		end

feature {NONE} -- Implementation

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [source_path: EL_DIR_PATH; query: STRING; edit: STRING]
		do
			create Result
			Result.source_path := ""
			Result.query := ""
			Result.edit := ""
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_existing_path_argument ("source", "Source tree directory"),
				optional_argument ("query", "Query command"),
				optional_argument ("edit", "Editing command [add_check_attribute]")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "manage_translation"

	Description: STRING = "Perform queries and/or edits on tree of Pyxis localization files"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{PYXIS_TRANSLATION_MANAGER_APP}, All_routines],
				[{PYXIS_TRANSLATION_MANAGER}, All_routines]
			>>
		end

end
