note
	description: "Flash xml network messenger"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

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