note
	description: "Vtd native xpath i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

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
