note
	description: "[
		Test ${EL_TODAYS_SENDMAIL_LOG} using data from: `test/data/network/mail.log'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 18:36:47 GMT (Sunday 23rd February 2025)"
	revision: "4"

class
	TEST_MAIL_LOG_ENTRIES

inherit
	EL_RECENT_MAIL_LOG_ENTRIES
		redefine
			Default_log_path
		end

create
	make

feature -- Constants

	Default_log_path: STRING
		once
			Result := "workarea/mail.log"
		end

end