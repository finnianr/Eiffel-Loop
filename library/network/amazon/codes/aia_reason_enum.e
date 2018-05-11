note
	description: "[
		Reasons for purchase/purchase revokation. Accessible via `{[$source AIA_SHARED_ENUMERATIONS]}.Reason_enum'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:01:17 GMT (Monday 23rd April 2018)"
	revision: "4"

class
	AIA_REASON_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			name as reason,
			export_name as to_upper_snake_case,
			import_name as from_upper_snake_case
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

end
