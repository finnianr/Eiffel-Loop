note
	description: "Bext server test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-08 11:02:53 GMT (Tuesday 8th February 2022)"
	revision: "14"

class
	BEXT_SERVER_TEST_APP

inherit
	EROS_SERVER_APPLICATION [BEXT_EROS_SERVER_COMMAND]

create
	make

feature {NONE} -- Implementation

	log_filter_set: EL_LOG_FILTER_SET [like Current]
		do
			create Result.make
		end

end