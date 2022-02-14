note
	description: "Installer application with Vision-2 GUI"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-14 12:36:19 GMT (Monday 14th February 2022)"
	revision: "4"

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
				Directory.Application_installation.set_path (Directory.current_working #+ "workarea/install")
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