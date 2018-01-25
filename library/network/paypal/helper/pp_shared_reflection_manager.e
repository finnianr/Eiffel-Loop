note
	description: "[
		Routine to initialize default values for reflection. Must be called before using API
		but `PP_NVP_API_CONNECTION' calls `initialize_reflection' for you on creation.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-24 13:12:41 GMT (Wednesday 24th January 2018)"
	revision: "3"

class
	PP_SHARED_REFLECTION_MANAGER

inherit
	EL_SHARED_REFLECTION_MANAGER

feature {NONE} -- Initialization

	Initialize_reflection
		once
			Reflection_manager.register_types (<<
				{EL_CURRENCY_CODE},
				{PP_PAYMENT_PENDING_REASON},
				{PP_PAYMENT_STATUS},
				{PP_TRANSACTION_TYPE},
				{PP_ADDRESS_STATUS}
			>>)
			Reflection_manager.register (<<
				create {PP_DATE_TIME}.make_now, create {EL_ISO_8601_DATE_TIME}.make_now
			>>)
		end
end
