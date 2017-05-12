note
	description: "Windows implementation of native xpath argument to vtd-xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-21 15:42:09 GMT (Friday 21st April 2017)"
	revision: "3"

class
	EL_VTD_NATIVE_XPATH_IMP

inherit
	EL_VTD_NATIVE_XPATH_I
		redefine
			make
		end

	TO_SPECIAL [NATURAL_16] -- Size of wchar_t on MSVC
		export
			{NONE} area
		end

create
	make

feature {NONE} -- Initialization

	make (xpath: READABLE_STRING_GENERAL)
		do
			make_empty_area (xpath.count + 1)
			share_area (xpath)
		end

feature {NONE} -- Implementation

	base_address: POINTER
		do
			Result := area.base_address
		end

	share_area (a_xpath: READABLE_STRING_GENERAL)
		local
			l_area: like area; i, count: INTEGER
		do
			count := a_xpath.count
			if count + 1 > area.capacity then
				area := area.resized_area (count + 1)
			end
			l_area := area
			l_area.wipe_out
			from i := 0 until i = count loop
				l_area.extend (a_xpath.item (i + 1).natural_32_code.as_natural_16)
				i := i + 1
			end
			l_area.extend (0)
		ensure then
			valid_count: area.count = a_xpath.count + 1
		end

end
