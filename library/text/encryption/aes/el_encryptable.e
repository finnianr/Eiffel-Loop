note
	description: "Encryptable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-16 14:08:00 GMT (Saturday 16th February 2019)"
	revision: "6"

class
	EL_ENCRYPTABLE

feature {NONE} -- Initialization

	make_default_encryptable
		do
			encrypter := Default_encrypter
		end

feature -- Element change

	set_encrypter (a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
		end

feature -- Status query

	has_default_encrypter: BOOLEAN
		do
			Result := encrypter = Default_encrypter
		end

feature -- Access

	encrypter: EL_AES_ENCRYPTER

	encrypted_size (byte_count: INTEGER): INTEGER
		do
			Result := (byte_count / encrypter.Block_size).ceiling * encrypter.Block_size
		end

feature {NONE} -- Constants

	Default_encrypter: EL_AES_ENCRYPTER
		once ("PROCESS")
			create Result
		end

end
