note
	description: "Summary description for {EL_ENCRYPTABLE_STORABLE_XML_ELEMENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_ENCRYPTABLE_STORABLE_XML_ELEMENT

inherit
	EL_STORABLE_XML_ELEMENT
		redefine
			make_eiffel_context
		end

	EL_ENCRYPTABLE

feature {NONE} -- Initialization

	make_eiffel_context
		do
			Precursor
			create encrypter
		end

feature {NONE} -- Conversion

	decrypted (base_64_text: STRING): STRING
			--
		do
			if Result.is_empty then
				Result := base_64_text
			else
				Result := encrypter.decrypted_base64 (base_64_text)
			end
		end

	encrypted (text: STRING): STRING
			--
		do
			if text.is_empty then
				Result := text
			else
				Result := encrypter.base64_encrypted (text)
			end
		end

end
