note
	description: "[
		Instant Access response codes with corresponding names accessible as `message'. 
		Accessible via `{[$source AIA_SHARED_ENUMERATIONS]}.Response_enum'. 
		See also class [$source AIA_PURCHASE_REASON].
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-28 8:39:01 GMT (Tuesday 28th April 2020)"
	revision: "6"

class
	AIA_RESPONSE_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_snake_case_upper,
			import_name as import_default
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

end
