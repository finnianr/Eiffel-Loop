note
	description: "Stream socket bytes written counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_WRITTEN_BYTE_COUNTING_LISTENER

inherit
	EL_BYTE_COUNTING_LISTENER
		rename
			byte_count as bytes_sent_count
		end
create
	make

feature {NONE} -- Implementation

	increment_byte_count
		do
			bytes_sent_count := bytes_sent_count + socket.bytes_sent
		end

end