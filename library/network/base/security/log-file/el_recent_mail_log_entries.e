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
	date: "2025-02-24 5:14:18 GMT (Monday 24th February 2025)"
	revision: "9"

class
	EL_RECENT_MAIL_LOG_ENTRIES

inherit
	EL_RECENT_LOG_ENTRIES
		rename
			intruder_list as spammer_list,
			update_intruder_list as update_spammer_list
		end

create
	make

feature -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/mail.log"
		end

feature {NONE} -- Implementation

	parsed_address (line: STRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 26 14:45:16 myching sm-mta[30359]: 39QEjFLv030359: rejecting commands from [103.187.190.12]
		local
			s: EL_STRING_8_ROUTINES
		do
			if attached s.bracketed_last (line, '[') as address and then address.occurrences ('.') = 3 then
				Result := IP_address.to_number (address)
			end
		end

	parse_lines (line_list: LIST [STRING])
		do
			across line_list as list loop
				if attached list.item as line
					and then across warning_list as warning some line.has_substring (warning.item) end
				then
					extend_intruder_list (line)
				end
			end
		end

feature {NONE} -- Constants

	Port: NATURAL_16 = 25
		-- SMTP port

	Warning_list: EL_STRING_8_LIST
		once
			Result := "Connection rate limit exceeded, Relaying denied, rejecting commands from"
		end
end