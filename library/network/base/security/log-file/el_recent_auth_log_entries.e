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
	date: "2025-03-10 17:57:38 GMT (Monday 10th March 2025)"
	revision: "12"

class
	EL_RECENT_AUTH_LOG_ENTRIES

inherit
	EL_RECENT_LOG_ENTRIES
		redefine
			check_line
		end

create
	make

feature {NONE} -- Line states

	find_disconnect (line: STRING)
		do
			if line.has_substring (Message.received_disconnect) then
				address_delimiter := ':'
				extend_intruder_list (line)
				state := agent check_line
			end
		end

	check_line (line: STRING)
		do
			if line.has_substring (Message.user_root_not_allowed) then
				state := agent find_disconnect

			elseif line.has_substring (Message.invalid_user) or else line.has_substring (Message.did_not_receive) then
				address_delimiter := End_of_line
				extend_intruder_list (line)

			elseif line.has_substring (Message.accepted_publickey) then
				address_delimiter := ' '
				white_listed_set.put (parsed_address (line))
			end
		end

feature {NONE} -- Implementation

	do_with (line: STRING)
		do
			state (line)
		end

	parsed_address (line: STRING): NATURAL
		-- Extract IP address from log entry refering to `address_delimiter'
		local
			start_index, end_index: INTEGER
		do
			start_index := line.substring_index (Word_from, 1)
			if start_index > 0 then
			-- Start of message
				start_index := start_index + Word_from.count
				inspect address_delimiter
					when ':', ' ' then
					-- Received disconnect from 218.92.0.136: 11:  [preauth]
					-- Accepted publickey for finnian from 95.45.149.152 port 38815
						end_index := line.index_of (address_delimiter, start_index) - 1

					when End_of_line then
					-- Invalid user john from 159.203.183.63
					-- Did not receive identification string from 218.92.0.246
						end_index := line.count
				else
				end
				if end_index > start_index then
					Result := Ip_address.substring_as_number (line, start_index, end_index)
				end
			end
		end

feature {NONE} -- Internal attributes

	address_delimiter: CHARACTER

feature {NONE} -- Constants

	End_of_line: CHARACTER = 'E'

	Message: TUPLE [
		accepted_publickey, did_not_receive, invalid_user, received_disconnect, user_root_not_allowed: IMMUTABLE_STRING_8
	]
		once
			create Result
			Tuple.fill_immutable (Result,
				"Accepted publickey, Did not receive identification, Invalid user, Received disconnect, User root not allowed"
			)
		end

	Port: NATURAL_16 = 22
		-- SSH port number

	Word_from: STRING
		once
			Result := " from "
		end

end