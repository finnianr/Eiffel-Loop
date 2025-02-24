note
	description: "[
		Test ${EL_RECENT_MAIL_LOG_ENTRIES} using `mail.*' files from `data/network/security'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-24 6:02:21 GMT (Monday 24th February 2025)"
	revision: "5"

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