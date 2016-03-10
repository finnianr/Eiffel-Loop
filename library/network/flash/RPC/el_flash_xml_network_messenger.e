note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_FLASH_XML_NETWORK_MESSENGER

inherit
	EL_XML_NETWORK_MESSENGER
		redefine
			send_message
		end

create
	make

feature {NONE} -- Implementation

	send_message
			--
		do
			if not net_exception_occurred then
				Precursor
				if not net_exception_occurred then
					data_socket.put_character (Nul.to_character)
				end
			else
				stop
			end
		rescue
			-- User has probably hit Alt-F4 breaking the network connection
			net_exception_occurred := true
			retry
		end

end


