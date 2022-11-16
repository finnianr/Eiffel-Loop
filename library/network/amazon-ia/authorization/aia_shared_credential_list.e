note
	description: "[
		Shared instance of [$source AIA_CREDENTIAL_LIST] or a conforming type,
		[$source AIA_STORABLE_CREDENTIAL_LIST] for example.
	]"
	notes: "[
		Make sure your application has created an instance of [$source AIA_CREDENTIAL_LIST] 
		(or a conforming type) before any calls to `Credential_list' are made from
		[$source AIA_REQUEST_MANAGER].
	]"
	tests: "See: [$source AMAZON_INSTANT_ACCESS_TEST_SET]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

deferred class
	AIA_SHARED_CREDENTIAL_LIST

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Credential_list: AIA_CREDENTIAL_LIST
		once
			Result := create {EL_CONFORMING_SINGLETON [AIA_CREDENTIAL_LIST]}
		end

end