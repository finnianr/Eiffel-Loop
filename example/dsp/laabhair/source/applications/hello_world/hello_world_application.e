indexing
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	HELLO_WORLD_APPLICATION

inherit
	LB_APPLICATION

	EL_SUB_APPLICATION
	
create
	make
	
feature -- Implementation

	main_window: HELLO_WORLD_MAIN_WINDOW is
			--
		once
			create Result.make
		end
	
	log_filter: ARRAY [ARRAY [STRING]] is
			--
		indexing
			once_status: global
		once
			Result := <<
				<< "HELLO_WORLD_APPLICATION",
					"*"
				>>,
				<< "HELLO_WORLD_MAIN_WINDOW",
					"*"
				>>,
				<< "HELLO_WORLD_CONFIGURATION",
					"*"
				>>,
				<< "EL_AUDIO_CLIP_SAVER",
					"*"
				>>,
				<< "SIMPLE_ANALYZER",
					"*"
				>>,
				<< "HELLO_WORLD_MICROPHONE_FLASH_UI_LISTENER",
					"*"
				>>,
				<< "EL_FLASH_XML_NETWORK_MESSENGER",
					"*"
				>>
				
			>>
		end
	
end -- class HELLO_WORLD_APPLICATION


