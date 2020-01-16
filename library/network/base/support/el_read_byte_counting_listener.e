note
	description: "Stream socket bytes read counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-16 12:21:12 GMT (Thursday 16th January 2020)"
	revision: "1"

class
	EL_READ_BYTE_COUNTING_LISTENER

inherit
	EL_BYTE_COUNTING_LISTENER
		rename
			byte_count as bytes_read_count
		end

create
	make

feature {NONE} -- Implementation

	increment_byte_count
		do
			bytes_read_count := bytes_read_count + socket.bytes_read
		end
end
