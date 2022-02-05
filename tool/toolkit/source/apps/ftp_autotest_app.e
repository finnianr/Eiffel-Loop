note
	description: "FTP test application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 15:45:30 GMT (Saturday 5th February 2022)"
	revision: "9"

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
