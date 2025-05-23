note
	description: "[
		Reasons for purchase/purchase revokation. Accessible via ${AIA_SHARED_ENUMERATIONS}.Reason_enum.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 8:01:32 GMT (Wednesday 30th April 2025)"
	revision: "16"

class
	AIA_REASON_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as Snake_case_upper,
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
			Result := {EL_CASE}.Upper
		end

end