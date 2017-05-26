note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-22 12:57:54 GMT (Monday 22nd May 2017)"
	revision: "2"

deferred class
	EL_INSTALLER_APP [INSTALLER_TYPE -> EL_APPLICATION_INSTALLER create make end]

inherit
	EL_VISION2_USER_INTERFACE [EL_APPLICATION_INSTALLER_WINDOW [INSTALLER_TYPE]]
		rename
			make as make_ui
		end

	EL_MODULE_LOG_MANAGER
		undefine
			default_create, copy
		end

feature {NONE} -- Initialization

	make
			--
		do
			make_ui (False)
			Log_manager.delete_logs
		end

end
