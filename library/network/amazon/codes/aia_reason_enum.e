note
	description: "Reasons for purchase/purchase revokation. Accessible via `AIA_SHARED_CODES'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:02:54 GMT (Monday 18th December 2017)"
	revision: "3"

class
	AIA_REASON_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			name as reason
		redefine
			export_name, import_name
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

feature {NONE} -- Implementation

	export_name: like Naming.Default_export
		do
			Result := agent Naming.to_upper_snake_case
		end

	import_name: like Naming.Default_import
		do
			Result := agent Naming.from_upper_snake_case
		end
end
