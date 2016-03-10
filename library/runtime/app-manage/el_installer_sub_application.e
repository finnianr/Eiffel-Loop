note
	description: "Summary description for {EL_INSTALLER_SUB_APPLICATION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
