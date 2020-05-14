note
	description: "Named thread"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-09 11:40:18 GMT (Saturday 9th May 2020)"
	revision: "6"

class
	EL_NAMED_THREAD

feature -- Access

 	name: ZSTRING
 		do
 			Result := new_name (generator)
 		end

feature {NONE} -- Factory

	new_name (a_class_name: STRING): ZSTRING
		do
			Result := a_class_name
			if Result.index_of ('_', 1) = 3 then
				Result.remove_head (3)
			end
 			Result.to_lower
  			Result.put (Result.item (1).upper, 1)
			Result.replace_character ('_', ' ')
		end
end
