note
	description: "[
		Instant Access response codes with corresponding names accessible as `message'.
		Accessible via `AIA_SHARED_CODES'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:01:30 GMT (Monday 18th December 2017)"
	revision: "3"

class
	AIA_RESPONSE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
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

	export_name: like Naming.Default_export
		do
			Result := agent Naming.to_upper_snake_case
		end

end
