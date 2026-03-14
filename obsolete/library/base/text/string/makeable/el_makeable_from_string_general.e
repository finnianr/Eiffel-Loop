note
	description: "Abstraction for a class that is makeable from a string and also convertible to a string"
	descendants: "[
			EL_MAKEABLE_FROM_STRING_GENERAL*
				[$source EL_MAKEABLE_FROM_STRING_8]*
					[$source AIA_CREDENTIAL_ID]
					[$source EL_BOOLEAN_REF]
						[$source PP_ADDRESS_STATUS]
					[$source EL_ENUMERATION_VALUE]*
						[$source AIA_PURCHASE_REASON]
						[$source EL_CURRENCY_CODE]
						[$source PP_PAYMENT_PENDING_REASON]
						[$source PP_PAYMENT_STATUS]
						[$source PP_TRANSACTION_TYPE]
					[$source EL_ENCODING]
					[$source EL_UUID]
				[$source EL_MAKEABLE_FROM_STRING_32]*
				[$source EL_MAKEABLE_FROM_ZSTRING]*
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-27 18:41:27 GMT (Monday 27th January 2020)"
	revision: "7"

deferred class
	EL_MAKEABLE_FROM_STRING_GENERAL

inherit
	EL_MAKEABLE
		rename
			make as make_default
		end

	DEBUG_OUTPUT
		rename
			debug_output as to_string
		end

feature -- Initialization

	make (string: like new_string)
		deferred
		end

	make_from_general (general: READABLE_STRING_GENERAL)
		do
			if attached {like new_string} general as string then
				make (string)
			else
				make (new_string (general))
			end
		end

feature -- Conversion

	to_string: like new_string
		deferred
		end

feature {NONE} -- Implementation

	new_string (general: READABLE_STRING_GENERAL): STRING_GENERAL
		deferred
		end
end
