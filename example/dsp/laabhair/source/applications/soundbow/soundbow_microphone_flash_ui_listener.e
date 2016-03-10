indexing
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	SOUNDBOW_MICROPHONE_FLASH_UI_LISTENER

inherit
	LB_MICROPHONE_FLASH_UI_LISTENER
		export
			{NONE} all
		end

	SOUNDBOW_SHARED_CONFIGURATION
	
create		
	make

feature {NONE} -- Implementation

	Flash_GUI_prog_name: STRING is "soundbow-display"

end

