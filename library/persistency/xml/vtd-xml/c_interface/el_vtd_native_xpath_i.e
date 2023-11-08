note
	description: "Abstraction for VTD native xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-08 13:55:06 GMT (Wednesday 8th November 2023)"
	revision: "9"

deferred class
	EL_VTD_NATIVE_XPATH_I [T]

inherit
	TO_SPECIAL [T]
		export
			{NONE} area
		end

	EL_STRING_32_CONSTANTS

feature {NONE} -- Initialization

	make_empty
		do
			make (Empty_string_32)
		end

	make (xpath: READABLE_STRING_GENERAL)
		do
			share_area (xpath.to_string_32)
		end

feature -- Element change

	share_area (a_xpath: STRING_32)
			-- Platform specific
		deferred
		ensure
			null_terminated: area [a_xpath.count] = null_terminator
		end

feature -- Access

	base_address: POINTER
		do
			Result := area.base_address
		end

feature {NONE} -- Implementation

	null_terminator: T
		deferred
		end
end