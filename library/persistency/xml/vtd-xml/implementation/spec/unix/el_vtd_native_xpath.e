note
	description: "Summary description for {EL_VTD_NATIVE_XPATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_VTD_NATIVE_XPATH

inherit
	TO_SPECIAL [CHARACTER_32]
		export
			{NONE} area
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			share_area ("")
		end

feature -- Element change

	share_area (a_xpath: STRING_32)
		do
			area := a_xpath.area
			area.put ('%U', a_xpath.count)
		end

feature -- Access

	base_address: POINTER
		do
			Result := area.base_address
		end

end
