note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-03 13:32:39 GMT (Wednesday 3rd April 2024)"
	revision: "18"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

	EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Templates

	Github_link_template: ZSTRING
		-- [link text] plus (web address)
		once
			Result := "[%S](%S)"
		end

feature {NONE} -- Strings

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Html: ZSTRING
		once
			Result := "html"
		end

	Html_reserved: ZSTRING
		once
			Result := "<>%"&"
		end

	Html_substitutes: ZSTRING
		-- temporary control character substitutes for `Html_reserved'
		-- Allows HTML to be inserted in note texts prior to XML escaping
		local
			array: ARRAY [NATURAL]; code: EL_ASCII
		once
			array := << code.Start_of_text, code.End_of_text, code.Shift_in, code.Shift_out >>
			create Result.make_from_zcode_area (array.area)
		ensure
			same_count: Result.count = Html_reserved.count
		end

feature {NONE} -- Constants

	Class_link_list: CLASS_LINK_LIST
		once
			create Result.make (20)
		end

	Link_type_normal: NATURAL_8 = 1
		-- ${MY_CLASS}

	Link_type_abstract: NATURAL_8 = 2
		-- ${MY_CLASS_I*}

	Link_type_parameterized: NATURAL_8 = 3
		-- ${MY_CONTAINER [G -> [MY_ITEM]]}


end