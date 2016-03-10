note
	description: "[
		RSAPrivateKey ::= SEQUENCE {
		    version           Version,
		    modulus           INTEGER,  -- n
		    publicExponent    INTEGER,  -- e
		    privateExponent   INTEGER,  -- d
		    prime1            INTEGER,  -- p
		    prime2            INTEGER,  -- q
		    exponent1         INTEGER,  -- d mod (p-1)
		    exponent2         INTEGER,  -- d mod (q-1)
		    coefficient       INTEGER,  -- (inverse of q) mod p
		    otherPrimeInfos   OtherPrimeInfos OPTIONAL
		}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-19 15:01:04 GMT (Saturday 19th December 2015)"
	revision: "6"

class
	EL_PKCS1_RSA_PRIVATE_KEY_READER

inherit
	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		redefine
			make
		end

	EL_PKCS1_RSA_FORMAT_CONSTANTS

	EL_MODULE_RSA

create
	make_from_file, make_from_lines

feature {NONE} -- Initialization

	make
		do
			Precursor
			create values.make (Variable_names.count); values.compare_objects
			create last_value.make (400)
			create last_name.make_empty
		end

	make_from_file (a_file_path: EL_FILE_PATH; encrypter: EL_AES_ENCRYPTER)
		local
			line_source: EL_ENCRYPTED_FILE_LINE_SOURCE
		do
			make
			create line_source.make (a_file_path, encrypter)
			do_once_with_file_lines (agent find_first_variable, line_source)
			extend_values
		end

	make_from_lines (lines: ARRAYED_LIST [ZSTRING])
		do
			make
			do_with_lines (agent find_first_variable, lines)
			extend_values
		end

feature -- Access

	values: HASH_TABLE [INTEGER_X, STRING]

feature {NONE} -- State handlers

	find_first_variable (line: ZSTRING)
		do
			if line.starts_with (Var_modulus) then
				find_next_variable (line)
				state := agent find_next_variable
			end
		end

	find_next_variable (line: ZSTRING)
		do
			if line.substring (1, 4).occurrences (' ') = 4 then
				last_value.append (line)
			else
				extend_values
				last_name := line.substring (1, line.index_of (':', 1) - 1)
				if last_name ~ Var_public_exponent then
					last_value := line.substring (line.index_of (':', 1) + 2, line.index_of ('(', 1) - 2)

				elseif Variable_names.has (last_name) then
					last_value.wipe_out
				end
			end
		end

feature {NONE} -- Implementation

	extend_values
		do
			if not last_name.is_empty then
				if last_value.is_integer then
					values [last_name] := create {INTEGER_X}.make_from_integer (last_value.to_integer)
				elseif last_value.has (':') then
					values [last_name] := RSA.integer_x_from_hex_byte_sequence (last_value)
				end
			end
		end

	last_value: ZSTRING

	last_name: ZSTRING

end
