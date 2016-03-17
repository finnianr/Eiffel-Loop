note
	description: "Summary description for {EL_SEND_MAIL_COMMAND_IMPL}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-11-08 14:10:34 GMT (Sunday 8th November 2015)"
	revision: "4"

class
	EL_SEND_MAIL_COMMAND_IMPL

inherit
	EL_COMMAND_IMPL

create
	make

feature -- Access

	Template: STRING = "sendmail -O DeliveryMode=background $to_address < $email_path"

end
