note
	description: "Development testing for [$source EL_HACKER_INTERCEPT_SERVLET] in Studio workbench mode"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_HACKER_INTERCEPT_TEST_SERVLET

inherit
	EL_HACKER_INTERCEPT_SERVLET
		redefine
			day_now, make, request_remote_address_32
		end

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initialization

	make (a_service: EL_HACKER_INTERCEPT_SERVICE)
		local
			test_path: FILE_PATH
		do
			Precursor (a_service)
			test_path := "$EIFFEL_LOOP/test/data/network/mail.log"
			test_path.expand
			mail_log.log_path.share (test_path.to_string)
		ensure then
			test_log_exists: Directory.new (mail_log.log_path).exists
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

	IP_list: EL_STRING_8_LIST
		-- some real world IP address that were trying to hack myching.software
		once
			Result := "172.178.81.138, 91.229.104.10, 206.232.3.170, 64.187.236.27, 195.140.176.35, 194.56.255.150"
		end

end
