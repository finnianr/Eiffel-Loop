note
	description: "Summary description for {TO_DO_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	TO_DO_LIST

inherit
	PROJECT_NOTES

feature -- Access

	c_compiler_warnings
		do
			-- Find out why addition of -Wno-write-strings does not suppress java warnings
			-- $ISE_EIFFEL/studio/spec/$ISE_PLATFORM/include/config.sh

			-- warning: deprecated conversion from string constant to 'char*' [-Wwrite-strings]

		end

	autotest
		do
			-- Make AutoTest suites
		end
end