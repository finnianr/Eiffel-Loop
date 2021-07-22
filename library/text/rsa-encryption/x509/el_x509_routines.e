note
	description: "X509 certificate routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-07-22 10:33:34 GMT (Thursday 22nd July 2021)"
	revision: "8"

class
	EL_X509_ROUTINES

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

feature -- Access

	public (crt_file_path: EL_FILE_PATH): EL_RSA_PUBLIC_KEY
		do
			if attached reader_command (crt_file_path) as cmd then
				cmd.execute
				Result := cmd.public_key
			end
		end

	private (key_file_path: EL_FILE_PATH; phrase: ZSTRING): EL_RSA_PRIVATE_KEY
		require
			valid_file: is_valid_pkcs1_file (key_file_path)
		do
			if attached key_reader_command (key_file_path, phrase) as cmd then
				cmd.execute
				Result := cmd.private_key
			end
		end

feature -- Status query

	is_valid_pkcs1_file (key_file_path: EL_FILE_PATH): BOOLEAN
		do
			if key_file_path.exists then
				Result := File_system.line_one (key_file_path).has_substring ("BEGIN ENCRYPTED PRIVATE KEY")
			end
		end

feature -- Commands

	reader_command (crt_file_path: EL_FILE_PATH): EL_X509_CERTIFICATE_READER_COMMAND_I
		do
			create {EL_X509_CERTIFICATE_READER_COMMAND_IMP} Result.make (crt_file_path)
		end

	key_reader_command (key_file_path: EL_FILE_PATH; phrase: ZSTRING): EL_X509_KEY_READER_COMMAND_I
		do
			create {EL_X509_KEY_READER_COMMAND_IMP} Result.make (key_file_path, phrase)
		end
end