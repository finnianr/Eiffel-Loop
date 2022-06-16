note
	description: "[
		Reasons for purchase/purchase revokation. Accessible via `{[$source AIA_SHARED_ENUMERATIONS]}.Reason_enum'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:33:47 GMT (Thursday 16th June 2022)"
	revision: "7"

class
	AIA_REASON_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as Snake_case_upper,
			name as reason
		end

create
	make

feature -- Access

	customer_service_request: NATURAL_8
		-- Customer calls up Amazon Customer Service who then decides to revoke the purchase

	fulfill: NATURAL_8
		-- fulfill customer purchase

	payment_problem: NATURAL_8
		-- Amazon's automated fraud investigation system detected a problem with payment

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			create Result.make_upper
		end

end