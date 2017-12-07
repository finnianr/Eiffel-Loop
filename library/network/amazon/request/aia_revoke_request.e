note
	description: "[
		 Instant Access request to
		 [https://s3-us-west-2.amazonaws.com/dtg-docs/api/once/revoke_purchase.html revoke a purchase]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:13:29 GMT (Thursday 7th December 2017)"
	revision: "1"

class
	AIA_REVOKE_REQUEST

inherit
	AIA_PURCHASE_REQUEST
		redefine
			default_response
		end

create
	make

feature {NONE} -- Implementation

	default_response: AIA_REVOKE_RESPONSE
		do
			create Result.make (Response_code.ok)
		end
end
