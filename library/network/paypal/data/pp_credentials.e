note
	description: "[
		Reads name value pairs from file encrypted using the Eiffel-Loop 
		`[./tool/toolkit/toolkit.html el_toolkit -crypto]' command line utility.
			
		See sub-application class: ${CRYPTO_COMMAND_SHELL_APP}
		
		Example file:
		
			# This is a comment
			
			USER: finnian
			SIGNATURE: A87F87C8789-AF89AA
			PWD: dragon-legend1
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:04:41 GMT (Wednesday 6th December 2023)"
	revision: "19"

class
	PP_CREDENTIALS

inherit
	PP_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER

	EL_SETTABLE_FROM_ZSTRING

create
	make

feature {NONE} -- Initialization

	make (credentials_path: FILE_PATH; decrypter: EL_AES_ENCRYPTER)
		local
			lines: EL_ENCRYPTED_PLAIN_TEXT_LINE_SOURCE
		do
			make_default
			create lines.make (credentials_path, decrypter)
			set_from_lines (lines, ':')
			lines.close
			http_parameter := to_parameter
		ensure
			no_empty_fields: across << user, pwd, signature >> as str all not str.item.is_empty end
		end

feature -- Access

	http_parameter: EL_HTTP_PARAMETER

feature -- Credentials

	pwd: STRING
		-- ASCII pass word

	signature: STRING
		-- ASCII API key

	user: STRING
		-- ASCII email address

end