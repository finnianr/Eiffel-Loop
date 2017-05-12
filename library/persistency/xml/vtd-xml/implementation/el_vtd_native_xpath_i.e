note
	description: "Summary description for {EL_VTD_NATIVE_XPATH_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-21 15:37:39 GMT (Friday 21st April 2017)"
	revision: "2"

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
