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
	date: "2020-09-15 10:20:46 GMT (Tuesday 15th September 2020)"
	revision: "63"

class
	FTP_AUTOTEST_APP

inherit
	EL_AUTOTEST_SUB_APPLICATION [TUPLE [FTP_TEST_SET]]

create
	make

end