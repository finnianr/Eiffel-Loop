note
	description: "[
		Command to obtain list of session information for the 
		[https://linux.die.net/man/1/screen Unix screen command].
	]"
	notes: "[
		Parses output as for example:

			screen -list
			
			There are screens on:
				3211.IP address blocking (18/03/24 14:31:56)	(Detached)
				3195.I Ching page service (18/03/24 14:31:40)	(Detached)
				3185.Screenshot service (18/03/24 14:31:34)	(Detached)
			3 Sockets in /var/run/screen/S-finnian.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-15 13:42:31 GMT (Saturday 15th February 2025)"
	revision: "4"

class
	EL_SCREEN_SESSIONS_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command,
			lines as name_list
		export
			{ANY} execute, name_list
			{NONE} all
		redefine
			do_with_lines, make_default, reset
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_with_name ("screen_list", "screen -list")
			set_success_code (256)
		end

	make_default
		do
			Precursor
			create session_list.make (10)
		end

feature -- Access

	session_list: EL_ARRAYED_LIST [like new_session_info]

feature {NONE} -- Implementation

	do_with_lines (output_lines: like new_output_lines)
		do
			across output_lines as list loop
				if list.cursor_index > 1 and then list.shared_item.starts_with_character ('%T')
					and then attached list.shared_item.substring_end (2) as line
				then
					session_list.extend (new_session_info (line))
					name_list.extend (session_list.last.name)
				end
			end
		end

	new_session_info (line: ZSTRING): TUPLE [id: INTEGER; name: ZSTRING; is_attached: BOOLEAN]
		-- parse `line' like:
		-- 	11053.IP address blocking	(17/03/24 15:11:06)	(Attached)
		local
			id: STRING; name, status: ZSTRING; index: INTEGER
		do
			index := 1
			id := line.substring_to_from ('.', $index)
			name := line.substring_to_from ('(', $index)
			name.remove_tail (1)
			status := line.substring_to_reversed ('(')
			Result := [id.to_integer, name, status.starts_with (Attach)]
		end

	reset
		do
			session_list.wipe_out
			Precursor
		end

feature {NONE} -- Constants

	Attach: ZSTRING
		once
			Result := "Attach"
		end
end