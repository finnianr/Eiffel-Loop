note
	description: "[
		Instant Access [https://s3-us-west-2.amazonaws.com/dtg-docs/api/once/fulfill_purchase.html purchase request]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-29 15:59:27 GMT (Sunday 29th November 2020)"
	revision: "4"

class
	AIA_PURCHASE_REQUEST

inherit
	AIA_REQUEST
		redefine
			new_enumerations
		end

create
	make

feature -- Access

	reason: NATURAL_8

	product_id: STRING

	user_id: STRING

	purchase_token: STRING

feature {NONE} -- Implementation

	default_response: AIA_PURCHASE_RESPONSE
		do
			create Result.make (response_enum.ok)
		end

	new_enumerations: like Default_enumerations
		do
			create Result.make (<<
				["reason", Reason_enum]
			>>)
		end

end