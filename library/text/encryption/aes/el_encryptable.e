note
	description: "Summary description for {EL_ENCRYPTABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_ENCRYPTABLE

feature -- Element change

	set_encrypter (a_encrypter: EL_AES_ENCRYPTER)
			--
		do
			encrypter := a_encrypter
		end

feature -- Access

	encrypter: EL_AES_ENCRYPTER

end
