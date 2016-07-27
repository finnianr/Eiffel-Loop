note
	description: "Summary description for {EL_THREAD_NAMING}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-03 6:02:24 GMT (Sunday 3rd July 2016)"
	revision: "3"

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
 			if a_class_name.starts_with (once "EL_") then
 				a_class_name.remove_head (3)
 			end
 			a_class_name.to_lower
 			Result := a_class_name
 			Result.replace_character ('_', ' ')
		end
end