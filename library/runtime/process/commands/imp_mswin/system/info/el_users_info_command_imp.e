note
	description: "Windows implementation of ${EL_USERS_INFO_COMMAND_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 16:25:39 GMT (Thursday 17th August 2023)"
	revision: "17"

class
	EL_USERS_INFO_COMMAND_IMP

inherit
	EL_USERS_INFO_COMMAND_I
		export
			{NONE} all
		redefine
			make, do_with_lines
		end

	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			do_with_lines as do_with_text_lines
		redefine
			make
		end

	EL_CHARACTER_32_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor {EL_PLAIN_TEXT_LINE_STATE_MACHINE}
			Precursor {EL_USERS_INFO_COMMAND_I}
		end

feature {NONE} -- State handlers

	find_command_completed (line: ZSTRING)
		do
			if line.has_substring (Command_completed) then
				state := final
			else
				across line.as_canonically_spaced.split (' ') as split loop
					if split.item_count > 0 then
						user_list.extend (split.item_copy)
					end
				end
			end
		end

	find_dashed_line (line: ZSTRING)
		do
			if line.starts_with (Hyphen * 3) then
				state := agent find_command_completed
			end
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like new_output_lines)
			--
		local
			home_list: EL_ZSTRING_LIST
		do
			-- fill `user_list'
			do_with_text_lines (agent find_dashed_line, new_net_user_list)
			create home_list.make (10)
			across lines as line loop
				if line.item.count > 0 then
					home_list.extend (line.item)
				end
			end
			-- prune users that do not have a matching directory in C:\Users
			create user_list.make_from_if (user_list, agent home_list.has)
		end

	new_net_user_list: EL_ZSTRING_LIST
		--  get list of users using output of `net user' command, as for example:

		--		User accounts for \\MACMINI
		--		-------------------------------------------------------------------------------
		--		Administrator            finnian                  Guest
		--		mäder
		--		The command completed successfully.
		local
			net_user: EL_CAPTURED_OS_COMMAND
		do
			create net_user.make_with_name ("net-user", "net user")
			net_user.execute
			Result := net_user.lines
		end

feature {NONE} -- Constants

	Command_completed: ZSTRING
		once
			Result := "command completed"
		end

	Template: STRING = "dir /B /AD-S-H $users_dir"
		-- Directories that do not have the hidden or system attribute set

end