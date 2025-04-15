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
	date: "2025-04-15 9:09:17 GMT (Tuesday 15th April 2025)"
	revision: "14"

class
	EL_RECENT_MAIL_LOG_ENTRIES

inherit
	EL_RECENT_LOG_ENTRIES

create
	make

feature {NONE} -- Implementation

	parsed_address (line: STRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 26 14:45:16 myching sm-mta[30359]: 39QEjFLv030359: rejecting commands from [103.187.190.12]
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if attached sg.super_8 (line).bracketed_last ('[') as address and then address.occurrences ('.') = 3 then
				Result := IP_address.to_number (address)
			end
		end

	do_with (line: STRING)
		do
			if across warning_list as warning some line.has_substring (warning.item) end then
				extend_intruder_list (line)
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