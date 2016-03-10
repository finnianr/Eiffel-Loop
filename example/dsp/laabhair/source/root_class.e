indexing
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	ROOT_CLASS

inherit
	EL_MULTI_APPLICATION_ROOT

create
	make

feature {NONE} -- Implementation

	Applications: ARRAY [EL_APPLICATION_CONTAINER_I] is
			-- 
		once
			Result := <<
				create {EL_APPLICATION_CONTAINER [SOUNDBOW_APPLICATION]}.make (
					"soundbow", "Octave to spectrum sound visualizer"
				),
				create {EL_APPLICATION_CONTAINER [HELLO_WORLD_APPLICATION]}.make (
					"hello_world", "Praat to Flash message test"
				)
				
			>>
		end
			
end -- class ROOT_CLASS
