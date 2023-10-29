note
	description: "[
		Analyses today's entries in sendmail log for SMTP relay abuse
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
	date: "2023-10-29 12:05:50 GMT (Sunday 29th October 2023)"
	revision: "4"

class
	EL_TODAYS_SENDMAIL_LOG

inherit
	EL_TODAYS_LOG_ENTRIES
		rename
			new_hacker_ip_list as new_spammer_ip_list,
			update_hacker_ip_list as update_spammer_ip_list
		end

create
	make

feature -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/mail.log"
		end

feature {NONE} -- Implementation

	new_ip_number (line: ZSTRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 26 14:45:16 myching sm-mta[30359]: 39QEjFLv030359: rejecting commands from [103.187.190.12]
		local
			start_index: INTEGER; address: STRING
		do
			start_index := line.substring_index (Message_start_marker, 1)
			if start_index > 0 then
			-- Start of message
				start_index := line.index_of ('[', start_index + Message_start_marker.count)
				if start_index > 0 then
					start_index := start_index + 1
					address := line.substring_to (']', $start_index)
					Result := IP_address.to_number (address)
				end
			end
		end

feature {NONE} -- Constants

	Message_start_marker: ZSTRING
		once
			Result := "]: "
		end

	Warning_list: EL_ZSTRING_LIST
		once
			Result := "Connection rate limit exceeded, Relaying denied"
		end
end