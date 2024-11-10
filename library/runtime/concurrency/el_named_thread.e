note
	description: "Named thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-10 17:31:28 GMT (Sunday 10th November 2024)"
	revision: "13"

class
	EL_NAMED_THREAD

inherit
	EL_LAZY_ATTRIBUTE
		rename
			new_item as new_name,
			cached_item as actual_name
		end

feature -- Access

	name: like new_name
		do
			Result := lazy_item
		end

feature -- Element change

	set_name (a_name: like new_name)
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
			Result.to_proper
		end

	new_name: READABLE_STRING_GENERAL
		do
			Result := new_english_name (generator)
		end
end