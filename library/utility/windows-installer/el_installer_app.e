note
	description: "Installer app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "6"

deferred class
	EL_INSTALLER_APP [INSTALLER_TYPE -> EL_APPLICATION_INSTALLER create make end]

inherit
	EL_VISION_2_USER_INTERFACE [EL_APPLICATION_INSTALLER_WINDOW [INSTALLER_TYPE]]
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