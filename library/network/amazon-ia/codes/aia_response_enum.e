note
	description: "[
		Instant Access response codes with corresponding names accessible as `message'. 
		Accessible via `{[$source AIA_SHARED_ENUMERATIONS]}.Response_enum'. 
		See also class [$source AIA_PURCHASE_REQUEST].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "10"

class
	AIA_RESPONSE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as snake_case_upper
		end

create
	make

feature -- Access

	fail_account_invalid: NATURAL_8

	fail_invalid_purchase_token: NATURAL_8

	fail_other: NATURAL_8

	fail_user_invalid: NATURAL_8

	fail_user_not_eligible: NATURAL_8

	ok: NATURAL_8

feature {NONE} -- Implementation

	snake_case_upper: EL_NAME_TRANSLATER
		do
			Result := snake_case_translater ({EL_CASE}.Upper)
		end

end