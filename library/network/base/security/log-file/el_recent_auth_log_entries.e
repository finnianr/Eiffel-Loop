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
	date: "2025-02-24 5:40:22 GMT (Monday 24th February 2025)"
	revision: "8"

class
	EL_RECENT_AUTH_LOG_ENTRIES

inherit
	EL_RECENT_LOG_ENTRIES
		redefine
			make
		end

	EL_STRING_STATE_MACHINE [STRING]
		rename
			make as make_machine
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_machine
			Precursor
		end

feature {NONE} -- Line states

	find_intrusion (line: STRING)
		do
			if line.has_substring (Message.user_root_not_allowed) then
				state := agent find_disconnect

			elseif line.has_substring (Message.invalid_user) then
				extend_intruder_list (line)
			end
		end

	find_disconnect (line: STRING)
		do
			if line.has_substring (Message.received_disconnect) then
				extend_intruder_list (line)
				state := agent find_intrusion
			end
		end

feature {NONE} -- Implementation

	parsed_address (line: STRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 29 10:49:33 myching sshd[8323]: Invalid user admin from 188.166.217.179
		local
			start_index, colon_index: INTEGER; address: STRING
		do
			start_index := line.substring_index (From_marker, 1)
			if start_index > 0 then
			-- Start of message
				start_index := start_index + From_marker.count
				colon_index := line.index_of (':', start_index)
				if colon_index > 0 then
				-- Received disconnect from 218.92.0.136: 11:  [preauth]
					address := line.substring (start_index, colon_index - 1)
				else
				-- Invalid user john from 159.203.183.63
					address := line.substring (start_index, line.count)
				end
				Result := IP_address.to_number (address)
			end
		end

	parse_lines (line_list: LIST [STRING])
		do
			do_with_lines (agent find_intrusion, line_list)
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

	Message: TUPLE [invalid_user, received_disconnect, user_root_not_allowed: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "Invalid user, Received disconnect, User root not allowed")
		end
end