note
	description: "[
		Vendor's response to Instant Access request for
		[https://s3-us-west-2.amazonaws.com/dtg-docs/api/once/revoke_purchase.html revoking a purchase]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:14:22 GMT (Thursday 7th December 2017)"
	revision: "1"

class
	AIA_REVOKE_RESPONSE

inherit
	AIA_PURCHASE_RESPONSE
		redefine
			Valid_responses
		end

create
	make

feature -- Constants

	Valid_responses: ARRAY [NATURAL_8]
		once
			Result := Precursor.twin
			Result [2] := Response_code.fail_invalid_purchase_token
		end
end
