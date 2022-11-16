note
	description: "Editable value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

deferred class
	EL_EDITABLE_VALUE

inherit
	ANY
		undefine
			out
		end
	
feature -- Element change

	set_item (string: STRING)
			--
		deferred
		end
	
feature -- 	Conversion

	out: STRING
			--
		deferred
		end

feature -- Access

	is_last_edit_valid: BOOLEAN
			-- Was there an error setting the item
			
	
feature {NONE} -- Implementation

	edit_listener: EL_EDIT_LISTENER
	
end