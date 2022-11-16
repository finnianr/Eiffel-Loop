note
	description: "Bext server test app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:03 GMT (Tuesday 15th November 2022)"
	revision: "15"

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