note
	description: "Installer application with Vision-2 GUI"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 16:38:53 GMT (Saturday 5th February 2022)"
	revision: "3"

class
	EL_INSTALLER_APP [W -> EL_INSTALLER_MAIN_WINDOW create make end]

inherit
	EL_STANDARD_INSTALLER_APP
		redefine
			Description, initialize, install_package
		end

	EL_APPLICATION_CONSTANTS

create
	make

feature {NONE} -- Initialization

	initialize
		do
			if App_option.test then
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