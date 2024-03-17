note
	description: "[
		Command to obtain list of session information for the 
		[https://linux.die.net/man/1/screen Unix screen command].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-17 19:21:21 GMT (Sunday 17th March 2024)"
	revision: "1"

class
	EL_SCREEN_SESSIONS_COMMAND

inherit
	EL_CAPTURED_OS_COMMAND
		rename
			make as make_command,
			lines as name_list
		export
			{NONE} all
			{ANY} execute, name_list
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

	do_with_lines (a_lines: like new_output_lines)
		do
			from a_lines.start until a_lines.after loop
				if attached a_lines.item as line
					and then line.occurrences ('(') >= 1 and then line.occurrences (')') >= 1
				then
					session_list.extend (new_session_info (line))
					name_list.extend (session_list.last.name)
				end
				a_lines.forth
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
			id.left_adjust
			name := line.substring_to_from ('(', $index)
			name.right_adjust
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