note
	description: "Summary description for {EL_LOGGED_XML_NETWORK_MESSENGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 8:30:28 GMT (Sunday 3rd July 2016)"
	revision: "1"

class
	EL_LOGGED_XML_NETWORK_MESSENGER

inherit
	EL_XML_NETWORK_MESSENGER
		undefine
			set_waiting, on_continue, on_start
		end

	EL_LOGGED_CONSUMER_THREAD [STRING]
		rename
			consume_product as send_message,
			make as make_consumer,
			product as xml_message
		undefine
			execute
		end

create
	make

end