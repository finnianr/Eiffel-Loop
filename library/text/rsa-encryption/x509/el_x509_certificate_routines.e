note
	description: "X509 certificate routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "13"

class
	EL_X509_CERTIFICATE_ROUTINES

inherit
	ANY

	EL_MODULE_FILE

feature -- Access

	public (crt_file_path: FILE_PATH): EL_RSA_PUBLIC_KEY
		do
			if attached public_reader (crt_file_path) as cmd then
				cmd.execute
				Result := cmd.public_key
			end
		end

	private (key_file_path: FILE_PATH; phrase: ZSTRING): EL_RSA_PRIVATE_KEY
		require
			valid_file: is_valid_pkcs1_file (key_file_path)
		do
			if attached private_reader (key_file_path, phrase) as cmd then
				cmd.execute
				Result := cmd.private_key
			end
		end

feature -- Status query

	is_valid_pkcs1_file (key_file_path: FILE_PATH): BOOLEAN
		do
			if key_file_path.exists then
				Result := File.line_one (key_file_path).has_substring ("BEGIN ENCRYPTED PRIVATE KEY")
			end
		end

feature -- Command factory

	public_reader (crt_file_path: FILE_PATH): EL_X509_PUBLIC_READER_COMMAND_I
		do
			create {EL_X509_PUBLIC_READER_COMMAND_IMP} Result.make (crt_file_path)
		end

	private_reader (key_file_path: FILE_PATH; phrase: ZSTRING): EL_X509_PRIVATE_READER_COMMAND_I
		do
			create {EL_X509_PRIVATE_READER_COMMAND_IMP} Result.make (key_file_path, phrase)
		end
end