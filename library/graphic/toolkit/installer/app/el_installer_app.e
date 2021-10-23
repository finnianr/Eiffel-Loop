note
	description: "Installer application with Vision-2 GUI"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-23 16:25:16 GMT (Saturday 23rd October 2021)"
	revision: "1"

class
	EL_INSTALLER_APP [W -> EL_INSTALLER_MAIN_WINDOW create make end]

inherit
	EL_STANDARD_INSTALLER_APP
		redefine
			Description, initialize, install_package
		end

	EL_INSTALLER_CONSTANTS

feature {NONE} -- Initialization

	initialize
		do
			if Application_option.test then
				Directory.Application_installation.set_path (Directory.current_working.joined_dir_path ("workarea/install"))
			end
			create gui.make (True)
		end

feature -- Basic operations

	install_package
		do
			gui.launch
		end

feature {NONE} -- Internal attributes

	gui: EL_VISION_2_USER_INTERFACE [W]

feature {NONE} -- Constants

	Description: ZSTRING
		once
			Result := "Installs " + Build_info.product + " application"
		end

end