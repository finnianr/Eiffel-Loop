note
	description: "Unix implementation of native xpath argument to vtd-xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 11:00:25 GMT (Tuesday 18th April 2017)"
	revision: "2"

class
	EL_VTD_NATIVE_XPATH_IMP

inherit
	EL_VTD_NATIVE_XPATH_I

	TO_SPECIAL [CHARACTER_32]
		export
			{NONE} area
		end

create
	make

feature -- Element change

	share_area (a_xpath: READABLE_STRING_GENERAL)
		local
			str_32: STRING_32
		do
			str_32 := a_xpath.to_string_32
			area := str_32.area
			area.put ('%U', str_32.count)
		end

feature -- Access

	base_address: POINTER
		do
			Result := area.base_address
		end
end
