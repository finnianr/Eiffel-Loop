note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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
