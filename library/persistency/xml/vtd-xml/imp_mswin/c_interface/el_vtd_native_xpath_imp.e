note
	description: "Windows implementation of native xpath argument to vtd-xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-15 10:52:18 GMT (Saturday 15th January 2022)"
	revision: "4"

class
	EL_VTD_NATIVE_XPATH_IMP

inherit
	EL_VTD_NATIVE_XPATH_I [NATURAL_16] -- Size of wchar_t on MSVC
		redefine
			make
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (xpath: READABLE_STRING_GENERAL)
		do
			make_empty_area (xpath.count + 1)
			Precursor (xpath)
		end

feature {NONE} -- Implementation

	share_area (a_xpath: STRING_32)
		local
			l_area: like area; i, count: INTEGER
			xp_area: SPECIAL [CHARACTER]
		do
			count := a_xpath.count
			if count + 1 > area.capacity then
				area := area.resized_area (count + 1)
			end
			xp_area := a_xpath.area
			l_area := area; l_area.wipe_out
			from i := 0 until i = count loop
				l_area.extend (xp_area [i].natural_32_code.as_natural_16)
				i := i + 1
			end
			l_area.extend (Null_terminator)
		ensure then
			valid_count: area.count = a_xpath.count + 1
		end

feature {NONE} -- Constants

	Null_terminator: NATURAL_16 = 0
end