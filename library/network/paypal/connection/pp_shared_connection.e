note
	description: "Access to shared instance of [$source PP_NVP_API_CONNECTION]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-30 14:49:32 GMT (Thursday 30th November 2017)"
	revision: "1"

deferred class
	PP_SHARED_CONNECTION

inherit
	EL_SHARED_CELL [PP_NVP_API_CONNECTION]
		rename
			item as paypal
		end

feature {NONE} -- Implementation

	cell: CELL [PP_NVP_API_CONNECTION]
		once
			create Result.put (new_paypal_connection)
		end

	new_paypal_connection: like paypal
			-- Circular reference to be overridden
		deferred
		end

end
