note
	description: "Installer sub application"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:22 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_INSTALLER_SUB_APPLICATION

inherit
	EL_SUB_APPLICATION

feature {EL_MULTI_APPLICATION_ROOT} -- Initiliazation

	make_installer (a_root: like root)
		require
			main_app_exists: across a_root.application_list as application some application.item.is_main end
		do
			root := a_root
			make
		end

feature -- Element change

	set_root (a_root: like root)
		do
			root := a_root
		end

feature {NONE} -- Implementation

	sub_applications: LIST [EL_SUB_APPLICATION]
		do
			Result := root.application_list
		end

	root: EL_MULTI_APPLICATION_ROOT [EL_BUILD_INFO]

end