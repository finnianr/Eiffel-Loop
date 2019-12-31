note
	description: "Test work distributer command options"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-12-31 11:11:42 GMT (Tuesday 31st December 2019)"
	revision: "1"

class
	TEST_WORK_DISTRIBUTER_COMMAND_OPTIONS

inherit
	EL_APPLICATION_COMMAND_OPTIONS
		redefine
			Help_text
		end

create
	make

feature -- Access

	max_priority: BOOLEAN

	priority_name: STRING
		do
			if max_priority then
				Result := "maximum"
			else
				Result := "normal"
			end
		end

feature {NONE} -- Constants

	Help_text: STRING
		once
			Result := Precursor + "[
				
				max_priority:
					Use maximum priority threads
			]"
		end

end
