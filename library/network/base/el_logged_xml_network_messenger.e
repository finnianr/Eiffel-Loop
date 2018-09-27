note
	description: "Logged xml network messenger"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:14 GMT (Thursday 20th September 2018)"
	revision: "5"

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