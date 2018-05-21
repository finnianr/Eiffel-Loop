note
	description: "Editable value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:05:05 GMT (Saturday 19th May 2018)"
	revision: "3"

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
