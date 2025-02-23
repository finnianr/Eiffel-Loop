note
	description: "[
		Development testing for ${EL_HACKER_INTERCEPT_SERVLET} using *.log data in
		
			$EIFFEL_LOOP/test/data/network
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-23 16:12:26 GMT (Sunday 23rd February 2025)"
	revision: "7"

class
	TESTABLE_404_INTERCEPT_SERVLET

inherit
	EL_404_INTERCEPT_SERVLET
		redefine
			request_remote_address_32, make, new_authorization_log, new_sendmail_log
		end

	EL_MODULE_DIRECTORY

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_404_INTERCEPT_SERVICE)
		do
			Precursor (a_service)
			across monitored_logs as list loop
				if attached (Log_dir + Directory.new (list.item.log_path).base) as log_path then
					list.item.log_path.share (log_path.to_string)
				end
			end
		ensure then
			test_log_exists: across monitored_logs as list all Directory.new (list.item.log_path).exists end
		end

feature {NONE} -- Factory

	new_authorization_log: TEST_AUTH_LOG_ENTRIES
		do
			create Result.make
		end

	new_sendmail_log: TEST_MAIL_LOG_ENTRIES
		do
			create Result.make
		end

feature {NONE} -- Implementation

	request_remote_address_32: NATURAL
		do
			index := index + 1
			Result := IP_address.to_number (IP_list.circular_i_th (index))
		end

feature {NONE} -- Internal attributes

	index: INTEGER

feature {NONE} -- Constants

	IP_list: EL_STRING_8_LIST
		-- some real world IP address that were trying to hack myching.software
		once
			Result := Invalid_auth_ip + ", " + Invalid_mail_ip +
				", 172.178.81.138, 91.229.104.10, 206.232.3.170, 64.187.236.27, 195.140.176.35, 194.56.255.150"
		end

	Invalid_auth_ip: STRING = "177.54.130.127"

	Invalid_mail_ip: STRING = "80.94.95.181"

	Log_dir: EL_DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "test/data/network"
		end

end