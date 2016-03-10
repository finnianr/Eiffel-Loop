note
	description: "Summary description for {CREATE_RSA_KEY_PAIR_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:21 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	CREATE_RSA_KEY_PAIR_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_MODULE_DIRECTORY

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			Args.set_integer_from_word_option ("bits", agent set_bits, 256)
			Args.set_string_from_word_option ("name", agent set_name, "RSA")
		end

feature -- Basic operations

	run
			--
		local
			key_pair: EL_STORABLE_RSA_KEY_PAIR
			public_key: SPECIAL [NATURAL_8]
			i: INTEGER
		do
			log.enter ("run")
			log.put_line ("Create key pair")
			create key_pair.make (bits)
			key_pair.save ("output", name)
			public_key := key_pair.public.modulus.as_bytes
			log.put_string ("PUBLIC KEY: << ")
			from i := 0 until i > public_key.upper loop
				if i > 0 then
					log.put_string (", ")
				end
				log.put_integer (public_key [i])
				i := i + 1
			end
			log.put_string (" >>")
			log.put_new_line
			log.exit
		end

feature -- Element change

	set_name (a_name: EL_ASTRING)
			--
		do
			name := a_name
		end

	set_bits (a_bits: INTEGER)
			--
		do
			bits := a_bits
		end

feature {NONE} -- Implementation

	bits: INTEGER

	name: EL_ASTRING

feature {NONE} -- Constants

	Option_name: STRING = "create_rsa_key_pair"

	Description: STRING = "Create a key pair"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{CREATE_RSA_KEY_PAIR_APP}, "*"],
				[{EL_RSA_KEY_PAIR}, "*"]
			>>
		end

end