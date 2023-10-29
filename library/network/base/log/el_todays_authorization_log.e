note
	description: "[
		Analyses today's entries in auth.log for hacker login attempts
	]"
	notes: "[
		Make current user member of administrator group **adm**
		
			sudo usermod -aG adm <username>
			
		Then re-login for command to take effect.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-29 12:22:28 GMT (Sunday 29th October 2023)"
	revision: "4"

class
	EL_TODAYS_AUTHORIZATION_LOG

inherit
	EL_TODAYS_LOG_ENTRIES

create
	make

feature {NONE} -- Implementation

	new_ip_number (line: ZSTRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 29 10:49:33 myching sshd[8323]: Invalid user admin from 188.166.217.179
		local
			start_index: INTEGER; address: STRING
		do
			start_index := line.substring_index (From_marker, 1)
			if start_index > 0 then
			-- Start of message
				address := line.substring_end (start_index + From_marker.count)
				Result := IP_address.to_number (address)
			end
		end

feature {NONE} -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/auth.log"
		end

	From_marker: ZSTRING
		once
			Result := " from "
		end

	Warning_list: EL_ZSTRING_LIST
		once
			Result := "Invalid user"
		end
end