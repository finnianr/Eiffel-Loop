note
	description: "Encryptable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-11 8:38:43 GMT (Friday 11th September 2020)"
	revision: "10"

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

	is_default: BOOLEAN
		do
			Result := encrypter = Default_encrypter or else encrypter.is_default
		end

feature -- Access

	encrypter: EL_AES_ENCRYPTER

feature {NONE} -- Constants

	Default_encrypter: EL_AES_ENCRYPTER
		once
			create Result
		end

end
