note
	description: "Summary description for {EL_ENCRYPTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-04-26 13:52:41 GMT (Sunday 26th April 2015)"
	revision: "3"

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

	Default_encrypter: EL_AES_ENCRYPTER
		once ("PROCESS")
			create Result
		end

	encrypter: EL_AES_ENCRYPTER

end
