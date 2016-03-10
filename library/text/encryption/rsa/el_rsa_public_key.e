note
	description: "Summary description for {EL_RSA_PUBLIC_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_RSA_PUBLIC_KEY

inherit
	RSA_PUBLIC_KEY
		rename
			make as make_with_exponent
		end

	EL_MODULE_BASE_64

	EL_MODULE_RSA

	EL_RSA_KEY

create
	make, make_from_array, make_from_base_64, make_from_hex_byte_sequence, make_from_manifest

feature {NONE} -- Initialization

	make_from_hex_byte_sequence (hex_byte_sequence: STRING)
			-- used to intialize from X509 cert
		do
			make (RSA.integer_x_from_hex_byte_sequence (hex_byte_sequence))
		end

	make_from_base_64 (base_64_string: STRING)
			--
		do
			make_from_array (Base_64.decoded_array (base_64_string))
		end

	make_from_array (a_modulus: ARRAY [NATURAL_8])
			--
		do
			make (Rsa.integer_x_from_array (a_modulus.area))
		end

	make_from_manifest (a_modulus: ARRAY [INTEGER])
			-- use to intialize from manifest containing factorized digits multiplied back together
			-- This form should make it more difficult for pirates to alter the machine code of executable
		local
			l_area: SPECIAL [NATURAL_8]
		do
			create l_area.make_filled (0, a_modulus.count)
			across a_modulus as n loop
				l_area [n.cursor_index - 1] := n.item.to_natural_8
			end
			make (Rsa.integer_x_from_array (l_area))
		end

	make (a_modulus: INTEGER_X)
			--
		do
			make_with_exponent (a_modulus, Default_exponent)
		end

feature -- Basic operations

	verify_base64 (message: INTEGER_X; base64_signature: STRING): BOOLEAN
			--
		do
			Result := verify (message, Rsa.integer_x_from_base64 (base64_signature))
		end

	encrypt_base64 (base64_message: STRING): INTEGER_X
			--
		local
			message: INTEGER_X
		do
			message := Rsa.integer_x_from_base64 (base64_message)
			Result := encrypt (message)
		end

	put_log
		do
			log.enter ("put_log")
			put_number (Var_modulus, modulus, True)
			put_number (Var_public_exponent, exponent, False)
			log.exit
		end
end
