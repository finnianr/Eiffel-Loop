note
	description: "Summary description for {SHARED_MEDIA_SYNC_CONFIGURATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-06 18:14:26 GMT (Thursday 6th June 2013)"
	revision: "2"

class
	SHARED_MEDIA_SYNC_CONFIGURATION

inherit
	EL_SHARED_APPLICATION_CONFIGURATION [MEDIA_SYNC_CONFIGURATION]
		rename
			config as media_sync_config
		end

feature {NONE} -- Implementation

	configuration_cell: EL_APPLICATION_CONFIG_CELL [MEDIA_SYNC_CONFIGURATION]
			--
		once
			create Result.make ("config.xml")
		end

end
