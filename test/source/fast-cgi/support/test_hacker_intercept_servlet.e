note
	description: "[
		Development testing for ${EL_HACKER_INTERCEPT_SERVLET} using *.log data in
		
			$EIFFEL_LOOP/test/data/network
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:27:43 GMT (Saturday 20th January 2024)"
	revision: "5"

class
	TEST_HACKER_INTERCEPT_SERVLET

inherit
	EL_HACKER_INTERCEPT_SERVLET
		redefine
			day_now, request_remote_address_32, new_monitored_logs
		end

	EL_MODULE_DIRECTORY

	SHARED_DEV_ENVIRON

create
	make

feature {NONE} -- Factory

	new_monitored_logs: ARRAY [EL_TODAYS_LOG_ENTRIES]
		do
			Result := <<
				create {TEST_AUTHORIZATION_LOG}.make,
				create {TEST_SENDMAIL_LOG}.make
			>>
			across Result as list loop
				if attached (Log_dir + Directory.new (list.item.log_path).base) as log_path then
					list.item.log_path.share (log_path.to_string)
				end
			end
		ensure then
			test_log_exists: across Result as list all Directory.new (list.item.log_path).exists end
		end

feature {NONE} -- Implementation

	request_remote_address_32: NATURAL
		do
			Result := IP_address.to_number (IP_list.circular_i_th (index))
		end

	day_now: INTEGER
		do
			Result := Precursor + index
			index := index + 1
		end

	index: INTEGER

feature {NONE} -- Constants

	Log_dir: EL_DIR_PATH
		once
			Result := Dev_environ.Eiffel_loop_dir #+ "test/data/network"
		end

	IP_list: EL_STRING_8_LIST
		-- some real world IP address that were trying to hack myching.software
		once
			Result := Invalid_auth_ip + ", " + Invalid_mail_ip +
				", 172.178.81.138, 91.229.104.10, 206.232.3.170, 64.187.236.27, 195.140.176.35, 194.56.255.150"
		end

	Invalid_auth_ip: STRING = "177.54.130.127"

	Invalid_mail_ip: STRING = "80.94.95.181"


end