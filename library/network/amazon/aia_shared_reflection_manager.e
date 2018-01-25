note
	description: "Summary description for {AIA_SHARED_REFLECTION_MANAGER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-24 11:54:53 GMT (Wednesday 24th January 2018)"
	revision: "2"

class
	AIA_SHARED_REFLECTION_MANAGER

inherit
	EL_SHARED_REFLECTION_MANAGER

feature {NONE} -- Implementation

	initialize_reflection
		once
			Reflection_manager.register_types (<< {AIA_CREDENTIAL_ID}, {AIA_PURCHASE_REASON} >>)
		end
end
