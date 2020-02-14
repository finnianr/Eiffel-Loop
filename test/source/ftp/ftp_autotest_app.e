note
	description: "Finalized executable tests for library [./library/ftp.html ftp.ecf]"
	notes: "[
		Command option: `-ftp_autotest'

		**Test Sets**

			[$source FTP_TEST_SET]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-14 13:54:05 GMT (Friday 14th February 2020)"
	revision: "62"

class
	FTP_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION

create
	make

feature {NONE} -- Implementation

	test_type, test_types_all: TUPLE [FTP_TEST_SET]
		do
			create Result
		end

end
