note
	description: "Sends an XML string representing a method invocation request"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_XML_NETWORK_MESSENGER

inherit
	EL_CONSUMER_THREAD [STRING]
		rename
			consume_product as send_message,
			make as make_consumer,
			product as xml_message
		redefine
			execute, is_visible_in_console
		end

	ASCII
		undefine
			is_equal, copy
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (port_num: INTEGER)
			--
		do
			make_consumer
			create listen_socket.make_server_by_port (port_num)
		end

feature -- Status query

	is_visible_in_console: BOOLEAN = True

feature {NONE} -- Implementation

	send_message
			--
		do
			log.enter ("send_message")
			data_socket.put_string (xml_message)
			log.put_string_field_to_max_length ("XML", xml_message, 80 )
			log.put_new_line
			log.exit
		rescue
			-- The network connection has probably been broken
			net_exception_occurred := true
		end

	execute
			--
		do
			listen_socket.listen (1)
			listen_socket.accept
			data_socket := listen_socket.accepted
			Precursor
			data_socket.close
			listen_socket.cleanup
		end

	listen_socket, data_socket: NETWORK_STREAM_SOCKET

	net_exception_occurred: BOOLEAN

end




