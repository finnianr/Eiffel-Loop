note
	description: "Unix implementation of native xpath argument to vtd-xml"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_VTD_NATIVE_XPATH_IMP

inherit
	EL_VTD_NATIVE_XPATH_I [CHARACTER_32]

create
	make, make_empty

feature {NONE} -- Implementation

	share_area (a_xpath: STRING_32)
		do
			if attached a_xpath.to_c then
				area := a_xpath.area
			end
		end

feature {NONE} -- Constants

	Null_terminator: CHARACTER_32 = '%U'
end