note
	description: "Encryptable"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "11"

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