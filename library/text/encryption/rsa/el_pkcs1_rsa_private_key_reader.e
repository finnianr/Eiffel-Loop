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
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_PKCS1_RSA_PRIVATE_KEY_READER

inherit
	EL_ENCRYPTED_PLAIN_TEXT_LINE_STATE_MACHINE

	EL_PKCS1_RSA_FORMAT_CONSTANTS

	EL_MODULE_RSA

create
	make_from_file

feature {NONE} -- Initialization

	make_from_file (a_file_path: EL_FILE_PATH; a_pass_phrase: STRING)
		do
			make (create {EL_AES_ENCRYPTER}.make_256 (a_pass_phrase))
			create values.make (Variable_names.count); values.compare_objects
			create last_value.make (400)
			create last_name.make_empty
			do_with_lines (agent find_first_variable, create {EL_FILE_LINE_SOURCE}.make (a_file_path))
			extend_values
		end

feature -- Access

	values: HASH_TABLE [INTEGER_X, EL_ASTRING]

feature {NONE} -- State handlers

	find_first_variable (line: EL_ASTRING)
		do
			if line.starts_with (Var_modulus) then
				find_next_variable (line)
				state := agent find_next_variable
			end
		end

	find_next_variable (line: EL_ASTRING)
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
			if last_value.is_integer then
				values [last_name] := create {INTEGER_X}.make_from_integer (last_value.to_integer)
			elseif last_value.has (':') then
				values [last_name] := RSA.integer_x_from_hex_byte_sequence (last_value)
			end
		end

	last_value: EL_ASTRING

	last_name: EL_ASTRING

end