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
	date: "2025-03-09 19:57:24 GMT (Sunday 9th March 2025)"
	revision: "10"

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

	make (a_tail_count: INTEGER)
		do
			make_machine
			Precursor (a_tail_count)
		end

feature {NONE} -- Line states

	find_disconnect (line: STRING)
		do
			if has_message (line, Message.received_disconnect) then
				extend_intruder_list (line)
				state := agent find_intrusion
			end
		end

	find_intrusion (line: STRING)
		do
			if line.has_substring (Message.user_root_not_allowed) then
				state := agent find_disconnect

			elseif has_message (line, Message.invalid_user) then
				extend_intruder_list (line)

			elseif has_message (line, Message.accepted_publickey) then
				white_list.extend (parsed_address (line))
			end
		end

feature {NONE} -- Implementation

	has_message (line: STRING; a_message: IMMUTABLE_STRING_8): BOOLEAN
		do
			if line.has_substring (a_message) then
				last_test := a_message
				Result := True
			else
				last_test := Void
			end
		end

	parse_lines (line_list: LIST [STRING])
		do
			do_with_lines (agent find_intrusion, line_list)
		end

	parsed_address (line: STRING): NATURAL
		-- Extract IP address from log entry
		-- Oct 29 10:49:33 myching sshd[8323]: Invalid user admin from 188.166.217.179
		local
			start_index, end_index: INTEGER
		do
			start_index := line.substring_index (From_marker, 1)
			if start_index > 0 then
			-- Start of message
				start_index := start_index + From_marker.count
				if last_test = Message.received_disconnect then
				-- Received disconnect from 218.92.0.136: 11:  [preauth]
					end_index := line.index_of (':', start_index) - 1

				elseif last_test = Message.accepted_publickey then
				-- Accepted publickey for finnian from 95.45.149.152 port 38815
					end_index := line.index_of (' ', start_index) - 1

				elseif last_test = Message.invalid_user then
				-- Invalid user john from 159.203.183.63
					end_index := line.count
				end
				if end_index > start_index then
					Result := Ip_address.substring_as_number (line, start_index, end_index)
				end
			end
		end

feature {NONE} -- Internal attributes

	last_test: detachable IMMUTABLE_STRING_8

feature {NONE} -- Constants

	Default_log_path: STRING
		once
			Result := "/var/log/auth.log"
		end

	From_marker: STRING
		once
			Result := " from "
		end

	Message: TUPLE [accepted_publickey, invalid_user, received_disconnect, user_root_not_allowed: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "Accepted publickey, Invalid user, Received disconnect, User root not allowed")
		end
	Port: NATURAL_16 = 22
		-- SSH port number

end