note
	description: "FTP test application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	FTP_AUTOTEST_APP

inherit
	EL_CRC_32_AUTOTEST_APPLICATION [FTP_TEST_SET]
		redefine
			new_command_options, description
		end

create
	make

feature {NONE} -- Implementation

	new_command_options: FTP_LOGIN_OPTIONS
		do
			create Result.make
		end

feature {NONE} -- Constants

	Description: STRING = "Test for class EL_FTP_PROTOCOL"

end