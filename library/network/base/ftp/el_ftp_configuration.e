note
	description: "FTP configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-19 14:04:54 GMT (Saturday 19th August 2023)"
	revision: "12"

class
	EL_FTP_CONFIGURATION

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
		redefine
			make_default
		end

	EL_FTP_CONSTANTS; EL_CHARACTER_8_CONSTANTS; EL_STRING_8_CONSTANTS

create
	make, make_default

convert
	make ({FTP_URL})

feature {NONE} -- Initialization

	make (a_url: FTP_URL)
		do
			make_default
			url.copy (a_url)
		end

	make_default
		do
			Precursor
			create credential.make_default
			create encrypted_url.make_empty
			create url.make (Empty_string_8)
		end

feature -- Access

	credential: EL_BUILDABLE_AES_CREDENTIAL

	url: FTP_URL

	user_home_dir: DIR_PATH
		do
			Result := char ('/') * 1 + url.path
		end

feature -- Status query

	is_authenticated: BOOLEAN

feature -- Element change

	authenticate
		local
			crypto: EL_USER_CRYPTO_OPERATIONS
		do
			crypto.validate (credential)
			create url.make (credential.new_aes_encrypter (256).decrypted_base_64 (encrypted_url))
			is_authenticated := True
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["encrypted_url/text()", agent do node.set_8 (encrypted_url) end],
				["credential",				 agent do set_next_context (credential) end]
			>>)
		end

feature {NONE} -- Internal attributes

	encrypted_url: STRING

end