note
	description: "Summary description for {TEST_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:31 GMT (Tuesday 2nd September 2014)"
	revision: "3"

deferred class
	TEST_APPLICATION

inherit
	EL_SUB_APPLICATION
		undefine
			option_name
		end

	EL_TESTABLE_APPLICATION

feature -- Basic operations

	normal_initialize
			--
		do
		end

	normal_run
		do
		end

end
