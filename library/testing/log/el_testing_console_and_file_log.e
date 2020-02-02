note
	description: "Testing console and file log"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-02 17:55:20 GMT (Sunday 2nd February 2020)"
	revision: "1"

class
	EL_TESTING_CONSOLE_AND_FILE_LOG

inherit
	EL_CONSOLE_AND_FILE_LOG
		redefine
			new_output
		end

create
	make

feature {NONE} -- Implementation

	new_output: EL_TESTING_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_TESTING_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create Result.make
			end
		end

end
