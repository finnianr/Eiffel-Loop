note
	description: "[
		Instant Access [https://s3-us-west-2.amazonaws.com/dtg-docs/api/once/fulfill_purchase.html purchase request]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-07 10:09:16 GMT (Thursday 7th December 2017)"
	revision: "1"

class
	AIA_PURCHASE_REQUEST

inherit
	AIA_REQUEST
		redefine
			new_default_values
		end

create
	make

feature -- Access

	reason: AIA_PURCHASE_REASON

	product_id: STRING

	user_id: STRING

	purchase_token: STRING

feature {NONE} -- Implementation

	default_response: AIA_PURCHASE_RESPONSE
		do
			create Result.make (Response_code.ok)
		end

	new_default_values: EL_ARRAYED_LIST [ANY]
		do
			Result := Precursor + create {AIA_PURCHASE_REASON}.make_default
		end

end
