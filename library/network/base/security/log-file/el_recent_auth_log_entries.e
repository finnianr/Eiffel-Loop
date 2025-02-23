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
	date: "2025-02-23 16:10:26 GMT (Sunday 23rd February 2025)"
	revision: "7"

class
	EL_RECENT_AUTH_LOG_ENTRIES

inherit
	EL_RECENT_LOG_ENTRIES

create
	make

feature {NONE} -- Implementation

	new_ip_number (line: STRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 29 10:49:33 myching sshd[8323]: Invalid user admin from 188.166.217.179
		local
			start_index: INTEGER; address: STRING
		do
			start_index := line.substring_index (From_marker, 1)
			if start_index > 0 then
			-- Start of message
				address := line.substring (start_index + From_marker.count, line.count)
				Result := IP_address.to_number (address)
			end
		end

feature {NONE} -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/auth.log"
		end

	From_marker: STRING
		once
			Result := " from "
		end

	Port: NATURAL_16 = 22
		-- SSH port number

	Warning_list: EL_STRING_8_LIST
		once
			Result := "Invalid user"
		end
end