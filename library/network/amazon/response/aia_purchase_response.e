note
	description: "[
		Vendor's response to Instant Access
		[https://s3-us-west-2.amazonaws.com/dtg-docs/api/once/fulfill_purchase.html purchase request]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:10:59 GMT (Thursday 7th December 2017)"
	revision: "1"

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
				Response_code.ok,
				Response_code.fail_user_not_eligible,
				Response_code.fail_user_invalid,
				Response_code.fail_other
			>>
		end
end
