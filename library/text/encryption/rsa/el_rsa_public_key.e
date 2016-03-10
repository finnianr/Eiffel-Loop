note
	description: "Summary description for {EL_RSA_PUBLIC_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

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
	make, make_from_array, make_from_hex_byte_sequence

feature {NONE} -- Initialization

	make_from_hex_byte_sequence (hex_byte_sequence: STRING)
			--
		do
			make (RSA.integer_x_from_hex_byte_sequence (hex_byte_sequence))
		end

	make_from_array (a_modulus: ARRAY [NATURAL_8])
			--
		do
			make (Rsa.integer_x_from_array (a_modulus.area))
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

end
