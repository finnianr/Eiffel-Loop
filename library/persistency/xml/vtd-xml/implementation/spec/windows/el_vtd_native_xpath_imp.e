note
	description: "Windows implementation of native xpath argument to vtd-xml"

	

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-04-18 11:00:14 GMT (Tuesday 18th April 2017)"
	revision: "2"

class
	EL_VTD_NATIVE_XPATH_IMP

inherit
	EL_VTD_NATIVE_XPATH_I

	TO_SPECIAL [NATURAL_16] -- Size of wchar_t on MSVC
		export
			{NONE} area
		end

create
	make

feature -- Element change

	share_area (a_xpath: READABLE_STRING_GENERAL)
		local
			l_area: like area; xpath_area: SPECIAL [CHARACTER_32]
			i, count: INTEGER
		do
			count := a_xpath.count
			if count + 1 > area.capacity then
				area := area.resized_area (count + 1)
			end
			l_area := area; xpath_area := a_xpath.area
			l_area.wipe_out
			from i := 0 until i = count loop
				l_area.extend (xpath_area.item (i).natural_32_code.as_natural_16)
				i := i + 1
			end
			l_area.extend (0)
		ensure
			valid_count: area.count = a_xpath.count + 1
		end

feature -- Access

	base_address: POINTER
		do
			Result := area.base_address
		end

end
