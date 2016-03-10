indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	HELLO_WORLD_CONFIGURATION_EDIT_WINDOW

inherit
	LB_BASIC_CONFIG_EDIT_DIALOG
		redefine
			add_fields
		end
		
	HELLO_WORLD_SHARED_CONFIGURATION
	
create
	make_child

feature {NONE} -- Initialization

	add_fields is
			--
		do
			Precursor
			add_integer_field (
				"Initial value for sample counter", Config.counter_start
			)
		end

end


