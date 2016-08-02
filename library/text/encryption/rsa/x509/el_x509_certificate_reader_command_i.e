note
	description: "[
		Parse public key from crt output text
		
		SAMPLE CERTIFICATE

		Certificate:
			Data:
				Version: 3 (0x2)
				Serial Number: 13356565485226223335 (0xb95c0d8aee26e6e7)
			Signature Algorithm: sha1WithRSAEncryption
				Issuer: C=IE, ST=Meath, L=Dunboyne, O=Yibook, OU=None, CN=Finnian/emailAddress=finnian@eiffel-loop.com
				Validity
					Not Before: May  2 12:48:51 2012 GMT
					Not After : Jan 27 12:48:51 2015 GMT
				Subject: C=IE, ST=Meath, L=Dunboyne, O=Yibook, OU=None, CN=Finnian/emailAddress=finnian@eiffel-loop.com
				Subject Public Key Info:
					Public Key Algorithm: rsaEncryption
						Public-Key: (1024 bit)
						Modulus:
							00:d9:61:6e:a7:03:21:2f:70:d2:22:38:d7:99:d4:
							bc:6d:55:7f:cc:97:9a:5d:8b:a3:d3:84:d3:2b:a2:
							1a:ba:67:3f:d5:17:68:e0:3d:a7:ed:23:5f:04:b6:
							8e:70:0d:f5:bc:d3:dd:03:cd:78:ec:4b:64:93:91:
							8a:4d:e5:d1:a9:01:4b:83:f9:2e:9c:a7:df:d8:6a:
							bc:1a:cf:80:f6:03:97:2a:a5:f8:1f:0e:02:81:51:
							14:cb:72:66:46:2a:b9:c2:f4:13:22:fd:d0:fc:4d:
							15:86:14:3b:5d:fc:25:65:26:31:5b:f9:d5:6d:a5:
							0d:26:e4:68:74:85:a7:0a:ad
						Exponent: 65537 (0x10001)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-21 11:31:41 GMT (Tuesday 21st June 2016)"
	revision: "1"

deferred class
	EL_X509_CERTIFICATE_READER_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as crt_file_path,
			set_path as set_crt_file_path
		export
			{NONE} all
			{ANY} execute
		undefine
			do_command, new_command_string
		redefine
			make_default, Var_name_path, crt_file_path
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		redefine
			call
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			make_machine
			create public_key.make (0xFFFFFF)
			create hex_byte_sequence.make_empty
			Precursor {EL_SINGLE_PATH_OPERAND_COMMAND_I}
		end

feature -- Access

	crt_file_path: EL_FILE_PATH

	public_key: EL_RSA_PUBLIC_KEY

feature {NONE} -- State handlers

	find_modulus (line: ZSTRING)
		do
			if line.starts_with (Field_modulus) then
				state := agent find_exponent
			end
		end

	find_exponent (line: ZSTRING)
		do
			if line.starts_with (Field_exponent) then
				create public_key.make_from_hex_byte_sequence (hex_byte_sequence)
				hex_byte_sequence.wipe_out
				state := agent final
			else
				hex_byte_sequence.append (line.to_string_8)
			end
		end

feature {NONE} -- Implementation

	do_with_lines (lines: like adjusted_lines)
			--
		do
			parse_lines (agent find_modulus, lines)
		end

	call (line: ZSTRING)
		do
			line.left_adjust
			Precursor (line)
		end

	hex_byte_sequence: STRING

feature {NONE} -- Constants

	Field_modulus: ZSTRING
		once
			Result := "Modulus:"
		end

	Field_exponent: ZSTRING
		once
			Result := "Exponent:"
		end

	Var_name_path: ZSTRING
		once
			Result := "crt_file_path"
		end

end