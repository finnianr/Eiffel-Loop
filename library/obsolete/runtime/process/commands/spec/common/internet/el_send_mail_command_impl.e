note
	description: "Summary description for {EL_SEND_MAIL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-05-16 17:20:45 GMT (Monday 16th May 2016)"
	revision: "5"

class
	EL_SEND_MAIL_COMMAND_IMPL

inherit
	EL_OS_COMMAND_IMPL

feature -- Access

	Template: STRING = "[
		sendmail -v $to_address < $email_path | grep -P "^... RCPT To|^... 55[0-9]" >> $log_path
	]"

-- sendmail -O DeliveryMode=background $to_address < $email_path

end