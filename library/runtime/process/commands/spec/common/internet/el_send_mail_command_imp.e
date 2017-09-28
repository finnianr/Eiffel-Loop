note
	description: "Summary description for {EL_SEND_MAIL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-21 16:49:14 GMT (Friday 21st July 2017)"
	revision: "5"

class
	EL_SEND_MAIL_COMMAND_IMP

inherit
	EL_SEND_MAIL_COMMAND_I
		export
			{NONE} all
		end

	EL_OS_COMMAND_IMP
		undefine
			make_default, execute, do_command, new_command_string
		end

create
	make

feature -- Access

	Template: STRING = "sendmail -v -fname $from_address $to_address < $email_path"

-- sendmail -v $to_address < $email_path | grep -P "^... RCPT To|^... 55[0-9]" >> $log_path
-- sendmail -O DeliveryMode=background $from_address $to_address < $email_path

end
