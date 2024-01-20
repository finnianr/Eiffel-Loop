note
	description: "[
		Shared instance of ${AIA_CREDENTIAL_LIST} or a conforming type,
		${AIA_STORABLE_CREDENTIAL_LIST} for example.
	]"
	notes: "[
		Make sure your application has created an instance of ${AIA_CREDENTIAL_LIST} 
		(or a conforming type) before any calls to `Credential_list' are made from
		${AIA_REQUEST_MANAGER}.
	]"
	tests: "See: ${AMAZON_INSTANT_ACCESS_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "9"

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