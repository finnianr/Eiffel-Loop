note
	description: "Summary description for {EL_VTD_NATIVE_XPATH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_VTD_NATIVE_XPATH

inherit
	TO_SPECIAL [NATURAL_16] -- Size of wchar_t on MSVC
		export
			{NONE} area
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			create area.make_empty (0)
			share_area ("")
		end

feature -- Element change

	share_area (a_xpath: STRING_32)
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
