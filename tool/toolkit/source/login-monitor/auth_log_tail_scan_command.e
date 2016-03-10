note
	description: "Summary description for {AUTHORIZATION_LOG_TAIL_COMMAND}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUTH_LOG_TAIL_SCAN_COMMAND

inherit
	EL_LINE_PROCESSED_OS_COMMAND
		rename
			find_line as read_ip_address
		redefine
			default_create, read_ip_address
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
		do
			create address_list.make (10)
			make_with_name ("cat /var/log/auth.log", "[
				cat /home/finnian/Desktop/failed-logins.txt
			]")
		end

feature -- Access

	address_list: EL_ASTRING_LIST

feature -- Element change

	reset
		do
			address_list.wipe_out
		end

feature {NONE} -- Line states

	read_ip_address (line: ASTRING)
		local
			address: ASTRING
		do
			address := line.substring_between (Word_from, Word_port, 1)
		end

feature {NONE} -- Constants

	Word_from: ASTRING
		once
			Result := "from"
		end

	Word_port: ASTRING
		once
			Result := "port"
		end
end
