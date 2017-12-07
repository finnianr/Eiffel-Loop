note
	description: "Shared credential list"
	notes: "[
		Override `new_credential_list' if you wish to implement your own storage scheme
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 13:44:18 GMT (Wednesday 6th December 2017)"
	revision: "1"

class
	AIA_SHARED_CREDENTIAL_LIST

inherit
	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	new_credential_list: like Credential_list
		do
			create {AIA_STORABLE_CREDENTIAL_LIST} Result.make (credentials_file_path, new_encrypter)
		end

	new_encrypter: EL_AES_ENCRYPTER
		do
			create Result.make_128 ("abc")
		end

	credentials_file_path: EL_FILE_PATH
		do
			Result := Directory.User_data + "credentials.dat"
		end

feature {NONE} -- Constants

	Credential_list: EL_ARRAYED_LIST [AIA_CREDENTIAL]
		once
			Result := new_credential_list
		end

end
