note
	description: "[
		Instant Access response codes with corresponding names accessible as `message'. 
		Accessible via `{[$source AIA_SHARED_ENUMERATIONS]}.Response_enum'. 
		See also class [$source AIA_PURCHASE_REQUEST].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:34:35 GMT (Thursday 16th June 2022)"
	revision: "8"

class
	AIA_RESPONSE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as Snake_case_upper
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

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			create Result.make_upper
		end

end