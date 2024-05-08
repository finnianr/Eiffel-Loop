note
	description: "FTP configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-05-08 6:15:03 GMT (Wednesday 8th May 2024)"
	revision: "20"

class
	EL_FTP_CONFIGURATION

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
		redefine
			make_default
		end

	EL_CHARACTER_8_CONSTANTS; EL_STRING_8_CONSTANTS

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

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
			create credential.make
			create url.make (Empty_string_8)
		end

feature -- Access

	checksum: NATURAL
		require
			not_authenticated: not is_authenticated
		do
			if attached encrypted_url as cipher and then attached crc_generator as crc then
				crc.add_string (cipher)
				crc.add_string (credential.target_base_64)
				crc.add_string (credential.salt_base_64)
				Result := crc.checksum
			end
		end

	credential: EL_BUILDABLE_AES_CREDENTIAL

	url: FTP_URL

	user_home_dir: DIR_PATH
		do
			Result := char ('/') * 1 + url.path
		end

feature -- Status query

	is_authenticated: BOOLEAN

	passive_mode: BOOLEAN

	prosite_ftp: BOOLEAN
		-- when `True' use fasthosts.co.uk Prosite FTP

feature -- Element change

	authenticate (a_phrase: detachable ZSTRING)
		local
			crypto: EL_USER_CRYPTO_OPERATIONS
		do
			if attached encrypted_url as cipher then
				if attached a_phrase as phrase then
					credential.try_validating (phrase)
					if not credential.is_valid then
						crypto.validate (credential, Void)
					end
				else
					crypto.validate (credential, Void)
				end
				create url.make (credential.new_aes_encrypter (256).decrypted_base_64 (cipher))
				encrypted_url := Void -- reclaim
			end
			is_authenticated := True
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
		do
			create Result.make (<<
				["@passive_mode",			 agent do passive_mode := node end],
				["@prosite_ftp",			 agent do prosite_ftp := node end],
				["encrypted_url/text()", agent do encrypted_url := node.to_string_8 end],
				["credential",				 agent do set_next_context (credential) end]
			>>)
		end

feature {NONE} -- Internal attributes

	encrypted_url: detachable STRING

end