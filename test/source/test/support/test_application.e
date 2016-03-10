note
	description: "Summary description for {TEST_APPLICATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-05-19 11:22:56 GMT (Tuesday 19th May 2015)"
	revision: "4"

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
