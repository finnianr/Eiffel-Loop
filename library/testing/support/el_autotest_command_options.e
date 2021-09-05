note
	description: "Autotest command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-05 9:32:06 GMT (Sunday 5th September 2021)"
	revision: "5"

class
	EL_AUTOTEST_COMMAND_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			Help_text
		end

create
	make

feature -- Status query

	test_set: STRING

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := joined (Precursor, "[
				test_set:
					Name of EQA test set to evaluate. Optionally execute a single test by appending
					'.' and name of test: Eg. MY_TESTS.test_something. The "test_" prefix is optional.
			]")
		end

end