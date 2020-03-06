note
	description: "Autotest command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 13:20:00 GMT (Friday 31st January 2020)"
	revision: "3"

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

	single: BOOLEAN

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := joined (Precursor, "[
				single:
					Evaluate only the single test in `evaluator_type'
			]")
		end

end