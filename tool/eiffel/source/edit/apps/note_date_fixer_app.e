note
	description: "[
		Fixes note dates with too many spaces as a result of a bug. For example

			date: "2018-09-20 10:06:24 GMT (Thursday  20th  September  2018)"
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 12:54:38 GMT (Tuesday 18th February 2020)"
	revision: "2"

class
	NOTE_DATE_FIXER_APP

inherit
	NOTE_EDITOR_APP
		redefine
			command, Option_name, test_run
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

	Option_name: STRING
		once
			Result := "date_fixer"
		end

end
