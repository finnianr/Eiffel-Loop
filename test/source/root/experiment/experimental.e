note
	description: "Experimental base class to check behaviour of Eiffel code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-26 10:15:12 GMT (Tuesday 26th October 2021)"
	revision: "4"

class
	EXPERIMENTAL

inherit
	ANY

	EL_MODULE_COMMAND

	EL_MODULE_LIO

	EL_MODULE_EIFFEL

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	assert (name: STRING; condition: BOOLEAN)
		do
			if condition then
				lio.put_labeled_string (name, "is true")
			else
				lio.put_labeled_string (name, "is false")
			end
			lio.put_new_line
		end

end