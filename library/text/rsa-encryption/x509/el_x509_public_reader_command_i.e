note
	description: "Reads public key from X509 certificate file with extension ''.crt''"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-23 19:00:18 GMT (Friday 23rd July 2021)"
	revision: "1"

deferred class
	EL_X509_PUBLIC_READER_COMMAND_I

inherit
	EL_X509_CERTIFICATE_READER_COMMAND_I
		rename
			rsa_key as public_key
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			create serial_number.make_empty
		end

feature -- Access

	public_key: EL_RSA_PUBLIC_KEY
		do
			create Result.make_from_pkcs1_table (data_table)
		end

	serial_number: STRING

feature {NONE} -- State handlers

	find_serial_number (line: ZSTRING)
		do
			if line.starts_with (Name.serial_number) then
				serial_number := field.value (line)
				serial_number.keep_head (serial_number.index_of ('(', 1) - 2)
				state := agent find_public_key
			end
		end

	do_with_lines (a_lines: like adjusted_lines)
			--
		do
			parse_lines (agent find_serial_number, a_lines)
		end

end