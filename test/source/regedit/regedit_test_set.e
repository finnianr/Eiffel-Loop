note
	description: "Registry reading test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-24 14:17:45 GMT (Sunday 24th September 2023)"
	revision: "1"

class
	REGEDIT_TEST_SET

inherit
	EL_EQA_TEST_SET

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["true_type_font_set",	agent test_true_type_font_set]
			>>)
		end

feature -- Test

	test_true_type_font_set
		local
			font: EL_FONT_REGISTRY_ROUTINES font_list: EL_ZSTRING_LIST
		do
			if attached font.true_type_font_set as font_set then
				font_list := "MS Gothic, MS PGothic, MS UI Gothic" -- msgothic.ttc
				assert ("TTC fonts present", across font_list as list all font_set.has (list.item) end)

				font_list := "Courier New, Linux Libertine G, Liberation Sans Narrow"
				assert ("TTF fonts present", across font_list as list all font_set.has (list.item) end)
			end
		end

end