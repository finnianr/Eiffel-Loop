note
	description: "Publisher constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-06 9:19:01 GMT (Thursday 6th June 2024)"
	revision: "23"

deferred class
	PUBLISHER_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Strings

	Current_dir_forward_slash: ZSTRING
		once
			Result := "./"
		end

	Github_link_template: ZSTRING
		-- [link text] plus (web address)
		once
			Result := "[%S](%S)"
		end

feature {NONE} -- HTML

	Html: ZSTRING
		once
			Result := "html"
		end

	Html_reserved: ZSTRING
		once
			Result := "<>%"&"
		end

feature {NONE} -- Class links

	Class_link_list: CLASS_LINK_LIST
		once
			create Result.make (20)
		end

	Link_type_normal, First_link_type: NATURAL_8 = 1
		-- ${MY_CLASS}

	Link_type_abstract: NATURAL_8 = 2
		-- ${MY_CLASS_I*}

	Link_type_parameterized: NATURAL_8 = 3
		-- ${MY_CONTAINER [G -> [MY_ITEM]]}

	Link_type_routine, Last_link_type: NATURAL_8 = 4
		-- ${MY_CLASS}.my_routine

end