note
	description: "Stream socket byte counter"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "9"

deferred class
	EL_BYTE_COUNTING_LISTENER

inherit
	EL_EVENT_LISTENER
		rename
			notify as increment_byte_count
		end

feature {NONE} -- Initialization

	make
		do
			socket := Default_socket
		end

feature -- Access

	byte_count: INTEGER_64

feature -- Element change

	reset
			--
		do
			byte_count := 0
		end

	set_socket (a_socket: like socket)
		do
			socket := a_socket
			reset
		end

feature {NONE} -- Implementation

	increment_byte_count
		deferred
		end

feature {NONE} -- Internal attributes

	socket: EL_STREAM_SOCKET

feature {NONE} -- Constants

	Default_socket: EL_NETWORK_STREAM_SOCKET
		once
			create Result.make
		end

end