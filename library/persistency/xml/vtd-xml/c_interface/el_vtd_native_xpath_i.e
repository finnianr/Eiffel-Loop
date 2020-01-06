note
	description: "Abstraction for VTD native xpath"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-26 12:44:28 GMT (Wednesday 26th December 2018)"
	revision: "5"

deferred class
	EL_VTD_NATIVE_XPATH_I

feature {NONE} -- Initialization

	make (xpath: READABLE_STRING_GENERAL)
		do
			share_area (xpath)
		end

feature -- Element change

	share_area (a_xpath: READABLE_STRING_GENERAL)
			-- Platform specific
		deferred
		end

feature -- Access

	base_address: POINTER
		deferred
		end

end
