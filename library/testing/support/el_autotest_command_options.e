note
	description: "Autotest command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-15 9:59:35 GMT (Tuesday 15th September 2020)"
	revision: "4"

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
					Name of EQA test set to evaluate
			]")
		end

end