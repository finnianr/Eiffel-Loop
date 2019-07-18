note
	description: "Installer app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 16:46:03 GMT (Monday 1st July 2019)"
	revision: "4"

deferred class
	EL_INSTALLER_APP [INSTALLER_TYPE -> EL_APPLICATION_INSTALLER create make end]

inherit
	EL_VISION2_USER_INTERFACE [EL_APPLICATION_INSTALLER_WINDOW [INSTALLER_TYPE]]
		rename
			make as make_ui
		end

	EL_MODULE_LOG_MANAGER

feature {NONE} -- Initialization

	make
			--
		do
			make_ui (False)
			Log_manager.delete_logs
		end

end
