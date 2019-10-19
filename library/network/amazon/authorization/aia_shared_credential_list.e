note
	description: "Shared credential list"
	notes: "[
		Override `new_credential_list' if you wish to implement your own storage scheme
	]"
	tests: "See: [$source AMAZON_INSTANT_ACCESS_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:58:21 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	AIA_SHARED_CREDENTIAL_LIST

inherit
	EL_ANY_SHARED

	EL_MODULE_DIRECTORY

feature {NONE} -- Implementation

	new_credential_list: like Credential_list
		do
			create {AIA_STORABLE_CREDENTIAL_LIST} Result.make (credentials_file_path, new_encrypter)
		end

	new_encrypter: EL_AES_ENCRYPTER
		do
			create Result.make ("abc", 128)
		end

	credentials_file_path: EL_FILE_PATH
		do
			Result := Directory.App_data + "credentials.dat"
		end

feature {NONE} -- Constants

	Credential_list: EL_ARRAYED_LIST [AIA_CREDENTIAL]
		once
			Result := new_credential_list
		end

end
