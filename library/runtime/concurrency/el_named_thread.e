note
	description: "Named thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 10:10:55 GMT (Friday 10th March 2023)"
	revision: "11"

class
	EL_NAMED_THREAD

inherit
	EL_LAZY_ATTRIBUTE
		rename
			item as name,
			new_item as new_name,
			actual_item as actual_name
		end

feature -- Element change

	set_name (a_name: like name)
		do
			actual_name := a_name
		end

feature {NONE} -- Factory

	new_english_name (a_class_name: STRING): ZSTRING
		do
			Result := a_class_name
			if Result.index_of ('_', 1) = 3 then
				Result.remove_head (3)
			end
			Result.replace_character ('_', ' ')
			Result.to_proper_case
		end

	new_name: READABLE_STRING_GENERAL
		do
			Result := new_english_name (generator)
		end
end