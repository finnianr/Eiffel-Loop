note
	description: "[
		Instant Access response codes with corresponding names accessible as `message'. 
		Accessible via ${AIA_SHARED_ENUMERATIONS}.Response_enum. 
		See also class ${AIA_PURCHASE_REQUEST}.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:02:27 GMT (Wednesday 30th April 2025)"
	revision: "17"

class
	AIA_RESPONSE_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as Snake_case_upper
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

	Snake_case_upper: EL_NAME_TRANSLATER
		once
			Result := snake_case_translater ({EL_CASE}.Upper)
		end

end