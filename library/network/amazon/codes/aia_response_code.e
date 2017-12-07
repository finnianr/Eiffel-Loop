note
	description: "[
		Instant Access response codes with corresponding names accessible as `message'.
		Accessible via `AIA_SHARED_CODES'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:02:19 GMT (Thursday 7th December 2017)"
	revision: "1"

class
	AIA_RESPONSE_CODE

inherit
	EL_STATUS_CODE_REFLECTION [NATURAL_8]
		rename
			code_name as message
		redefine
			export_name
		end

create
	make

feature -- Access

	ok: NATURAL_8

	fail_account_invalid: NATURAL_8

	fail_user_not_eligible: NATURAL_8

	fail_user_invalid: NATURAL_8

	fail_other: NATURAL_8

	fail_invalid_purchase_token: NATURAL_8

feature {NONE} -- Implementation

	export_name: like Default_import_name
		do
			Result := agent to_upper_snake_case
		end

end
