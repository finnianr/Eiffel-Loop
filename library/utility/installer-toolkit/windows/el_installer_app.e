note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-02-13 11:49:31 GMT (Wednesday 13th February 2013)"
	revision: "2"

deferred class
	EL_INSTALLER_APP [INSTALLER_TYPE -> EL_APPLICATION_INSTALLER create make end]

inherit
	EL_VISION2_USER_INTERFACE [EL_APPLICATION_INSTALLER_WINDOW [INSTALLER_TYPE]]	
		rename
			make_and_launch as make
		redefine
			Is_maximized, make
		end

feature {NONE} -- Initialization

	make
			-- 
		do
			Precursor
			delete_log_files
		end


feature {NONE} -- Constants

	Is_maximized: BOOLEAN
			-- 
		once
			Result := false
		end

end
