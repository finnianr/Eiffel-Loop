note
	description: "[
		Vendor's response to Instant Access
		[https://s3-us-west-2.amazonaws.com/dtg-docs/api/once/fulfill_purchase.html purchase request]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 6:21:06 GMT (Monday 18th December 2017)"
	revision: "2"

class
	AIA_PURCHASE_RESPONSE

inherit
	AIA_RESPONSE
		redefine
			Valid_responses
		end

create
	make

feature -- Constants

	Valid_responses: ARRAY [NATURAL_8]
		once
			Result := <<
				response_enum.ok,
				response_enum.fail_user_not_eligible,
				response_enum.fail_user_invalid,
				response_enum.fail_other
			>>
		end
end
