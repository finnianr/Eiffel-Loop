note
	description: "Database configuration"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at hex11software dot com"

	license: "All rights reserved"
	date: "2023-12-06 20:46:37 GMT (Wednesday 6th December 2023)"
	revision: "10"

class
	DATABASE_CONFIGURATION

inherit
	EL_BUILDABLE_FROM_PYXIS
		redefine
			make_default
		end

	EL_MODULE_ARGS; EL_MODULE_DIRECTORY; EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			make_from_file (Directory.App_configuration + "database-config.pyx")
		end

	make_default
			--
		do
			create ftp_mirror.make
			Precursor {EL_BUILDABLE_FROM_PYXIS}
		end

feature -- Status query

	is_logged_in: BOOLEAN
		do
		--	sharing database credential with ftp
			Result := credential.is_valid
		end

feature -- Basic operations

	login
		local
			crypto: EL_USER_CRYPTO_OPERATIONS;
		do
			if Args.has_value (PP) then
				ftp_mirror.try_authenticate (Args.value (PP))
			else
				crypto.set_validation_prompt ("Login passphrase")
				ftp_mirror.authenticate
				lio.put_new_line
			end
		end

feature -- Factory

	new_encrypter_128: EL_AES_ENCRYPTER
		require
			is_logged_in: is_logged_in
		do
			Result := credential.new_aes_encrypter (128)
		end

	new_encrypter_256: EL_AES_ENCRYPTER
		require
			is_logged_in: is_logged_in
		do
			Result := credential.new_aes_encrypter (256)
		end

feature {DATABASE} -- Access

	backup_version_01_path: FILE_PATH

	ftp_mirror: EL_FTP_MIRROR_BACKUP

feature {NONE} -- Implementation

	credential: EL_AES_CREDENTIAL
		do
			Result := ftp_mirror.credential
		end

feature {NONE} -- Build from XML

	Root_node_name: STRING = "database-config"

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			create Result.make (<<
				["@backup_version_01_path", agent do backup_version_01_path := node.to_expanded_file_path end],
				["ftp-mirror",					 agent do set_next_context (ftp_mirror) end]
			>>)
		end

feature {NONE} -- Constants

	PP: ZSTRING
		once
			Result := "pp"
		end

end
