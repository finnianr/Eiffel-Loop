note
	description: "Encryptable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-08 10:41:02 GMT (Friday 8th May 2020)"
	revision: "8"

class
	EL_ENCRYPTABLE

feature {NONE} -- Initialization

	make_default
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

feature {NONE} -- Constants

	Default_encrypter: EL_AES_ENCRYPTER
		once ("PROCESS")
			create Result
		end

end
