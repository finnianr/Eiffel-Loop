note
	description: "Summary description for {AUTHORIZATION_LOG_TAIL_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:31:42 GMT (Friday 18th December 2015)"
	revision: "4"

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
			make_with_name ("cat /var/log/auth.log", "cat /home/finnian/Desktop/failed-logins.txt")
		end

feature -- Access

	address_list: EL_ZSTRING_LIST

feature -- Element change

	reset
		do
			address_list.wipe_out
		end

feature {NONE} -- Line states

	read_ip_address (line: ZSTRING)
		local
			address: ZSTRING
		do
			address := line.substring_between (Word_from, Word_port, 1)
		end

feature {NONE} -- Constants

	Word_from: ZSTRING
		once
			Result := "from"
		end

	Word_port: ZSTRING
		once
			Result := "port"
		end
end
