note
	description: "Eros test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-20 9:49:40 GMT (Monday 20th January 2020)"
	revision: "2"

class
	EROS_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare, on_clean
		end

	EROS_REMOTE_CALL_CONSTANTS undefine default_create end

feature {NONE} -- Initiliazation

	on_prepare
			--
		do
			create connection.make (8000, "localhost")
			create server.make
		end

feature -- Tests

	test_fft
		local
			fft: FFT_COMPLEX_DOUBLE_PROXY
			signal_math: SIGNAL_MATH_PROXY
		do
			server.launch
			connection.set_inbound_type (Type_plaintext)
			connection.set_outbound_type (Type_plaintext)

			create fft.make (connection)
			create signal_math.make (connection)
		end

feature {NONE} -- Implementation

	on_clean
		do
			server.wait_to_stop
			connection.close
		end

feature {NONE} -- Internal attributes

	connection: EROS_CLIENT_CONNECTION

	server: EROS_SERVER_THREAD

end
