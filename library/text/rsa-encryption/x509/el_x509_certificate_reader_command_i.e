note
	description: "[
		Parse RSA key certificate from output text
		
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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-23 19:01:30 GMT (Friday 23rd July 2021)"
	revision: "9"

deferred class
	EL_X509_CERTIFICATE_READER_COMMAND_I

inherit
	EL_FILE_PATH_OPERAND_COMMAND_I
		rename
			file_path as crt_file_path,
			set_file_path as set_crt_file_path
		export
			{NONE} all
			{ANY} execute
		undefine
			do_command, new_command_parts
		redefine
			make_default
		end

	EL_CAPTURED_OS_COMMAND_I
		undefine
			make_default
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine,
			do_with_lines as parse_lines
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			make_machine
			create data_table.make (7)
			Precursor {EL_FILE_PATH_OPERAND_COMMAND_I}
			left_adjusted := True
		end

feature -- Access

	data_table: HASH_TABLE [STRING, STRING]

	rsa_key: EL_REFLECTIVE_RSA_KEY
		require
			enough_fields: data_table.count = data_field_count
		deferred
		ensure
			matches_key_size: key_size = Result.modulus.bits
		end

feature -- Measurement

	data_field_count: INTEGER
		do
			Result := Data_fields.count - 1
		end

	key_size: INTEGER
		-- key size in bits

feature {NONE} -- State handlers

	find_data_field (line: ZSTRING; index: INTEGER)
		local
			value: ZSTRING
		do
			if line.starts_with (Data_fields.last) then
				state := final
			elseif line.starts_with (Data_fields [index]) then
				state := agent find_data_field (?, index + 1)
				if Data_fields [index] ~ Name.exponent then
					value := line.substring_between (Bracket.left, Bracket.right, 1)
					value.remove_head (2)
					data_table.put (value, Data_fields [index])
				else
					data_table.put (create {STRING}.make_empty, Data_fields [index])
				end
			else
				line.append_to_string_8 (data_table.found_item)
			end
		end

	find_public_key (line: ZSTRING)
		local
			value: ZSTRING
		do
			if line.starts_with (Name.key_size) then
				value := line.substring_between (Bracket.left, Bracket.right, 1)
				value.remove_tail (4)
				key_size := value.to_integer
				state := agent find_data_field (?, 1)
			end
		end

feature {NONE} -- Implementation

	field: EL_COLON_FIELD_ROUTINES
		do
		end

feature {NONE} -- Constants

	Bracket: TUPLE [left, right: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "(, )")
		end

	Data_fields: EL_ZSTRING_LIST
		once
			Result := "Modulus, Exponent, X509v3"
		end

	Field_names: STRING
		once
			Result := "Exponent, Public-Key, Serial Number"
		end

	Name: TUPLE [exponent, key_size, serial_number: ZSTRING]
		once
			create Result
			Tuple.fill (Result, Field_names)
		end

end