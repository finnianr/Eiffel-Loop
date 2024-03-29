note
	description: "Encryptable storable xml element"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 8:59:16 GMT (Monday 21st November 2022)"
	revision: "7"

deferred class
	EL_ENCRYPTABLE_STORABLE_XML_ELEMENT

inherit
	EL_STORABLE_XML_ELEMENT
		redefine
			make_default
		end

	EL_ENCRYPTABLE
		undefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_STORABLE_XML_ELEMENT}
			create encrypter
		end

feature {NONE} -- Conversion

	decrypted (base_64_text: STRING): STRING
			--
		do
			if Result.is_empty then
				Result := base_64_text
			else
				Result := encrypter.decrypted_base_64 (base_64_text)
			end
		end

	encrypted (text: STRING): STRING
			--
		do
			if text.is_empty then
				Result := text
			else
				Result := encrypter.base_64_encrypted (text)
			end
		end

end