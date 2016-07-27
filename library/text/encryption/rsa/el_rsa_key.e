note
	description: "Summary description for {EL_RSA_KEY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 10:54:00 GMT (Friday 18th December 2015)"
	revision: "4"

deferred class
	EL_RSA_KEY

inherit
	EL_MODULE_BASE_64

	EL_MODULE_RSA

	EL_MODULE_LOG

	EL_PKCS1_RSA_FORMAT_CONSTANTS

feature -- Basic operations

	put_log
		deferred
		end

feature {NONE} -- Implementation

	put_number (label: ZSTRING; number: INTEGER_X; indefinite_length: BOOLEAN)
			-- indefinite_length is a special case that indicates a form of encoding, known as "indefinite-length encoding,"
			-- is being used, in which case the end of this ASN.1 value's data is marked by two consecutive zero-value octets.
		local
			bytes: SPECIAL [NATURAL_8]; line: STRING
			i: INTEGER
		do
			bytes := number.as_bytes
			log.put_labeled_string (label, "")
			log.put_new_line
			create line.make (3 * 15)
			if indefinite_length then
				line.append ("00:")
			end
			from i := 0 until i > bytes.upper loop
				line.append (bytes.item (i).to_hex_string.as_lower)
				line.append_character (':')
				if line.full then
					log.put_line (line)
					line.wipe_out
				end
				i := i + 1
			end
			log.put_line (line)
		end

	Default_exponent: INTEGER_X
		once
			create Result.make_from_integer (65537)
		end

end