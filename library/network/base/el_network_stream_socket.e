note
	description: "Summary description for {EL_NETWORK_STREAM_SOCKET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-29 11:33:46 GMT (Sunday 29th October 2017)"
	revision: "3"

class
	EL_NETWORK_STREAM_SOCKET

inherit
	NETWORK_STREAM_SOCKET
		rename
			put_string as put_encoded_string_8
		undefine
			read_stream, readstream
		redefine
			make, do_accept
		end

	EL_MODULE_EXCEPTION
		rename
			Exception as Mod_exception
		end

	EL_STREAM_SOCKET

create
	make, make_client_by_port, make_server_by_port

feature -- Initialization

	make
		do
			Precursor
			make_latin_1
		end

feature -- Status query

	is_client_connected: BOOLEAN
			--
		do
			if attached {like Current} accepted as client then
				Result := true
			end
		end

feature {NONE} -- Implementation

	do_accept (other: separate like Current; a_address: attached like address)
			-- Accept a new connection.
			-- The new socket is stored in `other'.
			-- If the accept fails, `other.is_created' is still False.
		local
			retried: BOOLEAN
			pass_address: like address
			return: INTEGER;
			l_last_fd: like fd
		do
			if not retried then
				pass_address := a_address.twin
				l_last_fd := last_fd
				return := c_accept (fd, fd1, $l_last_fd, pass_address.socket_address.item, accept_timeout);
				last_fd := l_last_fd
				if return > 0 then
					other.make_from_descriptor_and_address (return, a_address)
					other.set_peer_address (pass_address)
						-- We preserve the blocking state specified on Current.
					if is_blocking then
						other.set_blocking
					else
						other.set_non_blocking
					end
				end
			end
		rescue
			if Mod_exception.is_termination_signal (exception_manager.last_exception) then
				exception_manager.last_exception.raise
			elseif not assertion_violation then
				retried := True
				retry
			end
		end
end
