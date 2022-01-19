note
	description: "Extends [$source EL_CONSOLE_ONLY_LOG] for regression testing"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-31 11:01:59 GMT (Friday 31st January 2020)"
	revision: "5"

class
	EL_TESTING_CONSOLE_ONLY_LOG

inherit
	EL_CONSOLE_ONLY_LOG
		redefine
			new_output
		end

create
	make

feature {NONE} -- Implementation

	new_output: EL_CONSOLE_LOG_OUTPUT
		do
			if Console.is_highlighting_enabled then
				create {EL_TESTING_HIGHLIGHTED_CONSOLE_LOG_OUTPUT} Result.make
			else
				create {EL_TESTING_CONSOLE_LOG_OUTPUT} Result.make
			end
		end

end
