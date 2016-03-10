note
	description: "Summary description for {EL_INTRUSION_SCANNER_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 11:06:26 GMT (Friday 18th December 2015)"
	revision: "4"

class
	LOGIN_MONITOR_COMMAND

inherit
	EL_COMMAND

	EL_MODULE_LOG

feature {EL_COMMAND_CLIENT} -- Initialization

	make
		do
			create address_set.make_equal (11)
			create auth_log_scan_command
		end

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			auth_log_scan_command.execute
			across auth_log_scan_command.address_list as address loop
				if not address_set.has (address.item) then
					address_set.put (address.item)
					block_ip (address.item)
				end
			end
			log.exit
		end

feature {NONE} -- Implementation

	block_ip (ip_address: ZSTRING)
		do
			log.put_labeled_string ("Blocking IP address", ip_address)
			log.put_new_line
		end

	auth_log_scan_command: AUTH_LOG_TAIL_SCAN_COMMAND

	address_set: EL_HASH_SET [ZSTRING]

end
