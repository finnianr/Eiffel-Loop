note
	description: "Summary description for {ENCRYPT_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:34 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	ENCRYPT_TEXT_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end

	EL_ENCRYPTABLE

	EL_MODULE_BASE_64

	EL_MODULE_USER_INPUT

create
	make

feature {NONE} -- Initiliazation

	initialize
			--
		do
			pass_phrase := User_input.line ("Enter passphrase")
			text := User_input.line ("Enter text")
			text.replace_substring_all ("%%N", "%N")
			create encrypter.make_256 (pass_phrase)
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			log.put_string_field ("Key as base64", Base_64.encoded_special (encrypter.key_data))
			log.put_new_line
			log.put_string ("Key array: " + encrypter.out)
			log.put_new_line
			log.put_string_field ("Cipher text", encrypter.base64_encrypted (text))
			log.put_new_line
			log.exit
		end

feature {NONE} -- Implementation

	pass_phrase: STRING

	text: STRING

feature {NONE} -- Constants

	Option_name: STRING = "encrypt_text"

	Description: STRING = "Encrypt text with pass phrase"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{ENCRYPT_TEXT_APP}, "*"]
			>>
		end

end
