note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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


