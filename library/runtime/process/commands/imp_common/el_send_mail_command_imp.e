note
	description: "Implementation of [$source EL_SEND_MAIL_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-05-21 7:49:06 GMT (Sunday 21st May 2023)"
	revision: "13"

class
	EL_SEND_MAIL_COMMAND_IMP

inherit
	EL_SEND_MAIL_COMMAND_I
		export
			{NONE} all
		end

	EL_CAPTURED_OS_COMMAND_IMP
		undefine
			getter_function_table, execute
		end

create
	make

feature -- Access

	Template: STRING = "sendmail -v -fname $from_address $to_address < $email_path"

-- sendmail -v $to_address < $email_path | grep -P "^... RCPT To|^... 55[0-9]" >> $log_path
-- sendmail -O DeliveryMode=background $from_address $to_address < $email_path

end