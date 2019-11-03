note
	description: "[
		Fixes note dates with too many spaces as a result of a bug. For example

			date: "2018-09-20 10:06:24 GMT (Thursday  20th  September  2018)"
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	NOTE_DATE_FIXER_APP

inherit
	NOTE_EDITOR_APP
		redefine
			command, Log_filter, Option_name, test_run
		end

feature -- Basic operations

	test_run
			--
		do
			Test.do_file_tree_test ("latin1-sources", agent test_edit, 1844516999)
		end

feature {NONE} -- Implementation

	command: NOTE_DATE_FIXER_COMMAND

feature {NONE} -- Constants

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{NOTE_DATE_FIXER_APP}, All_routines],
				[{NOTE_DATE_FIXER_COMMAND}, All_routines],
				[{DATE_NOTE_EDITOR}, All_routines]
			>>
		end

	Option_name: STRING
		once
			Result := "date_fixer"
		end

end
