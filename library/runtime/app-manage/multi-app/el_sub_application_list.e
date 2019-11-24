note
	description: "List of sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-24 18:30:57 GMT (Sunday 24th November 2019)"
	revision: "12"

class
	EL_SUB_APPLICATION_LIST

inherit
	EL_ARRAYED_LIST [EL_SUB_APPLICATION]
		rename
			make as make_list
		redefine
			make_empty
		end

	EL_MODULE_ARGS

	EL_MODULE_EIFFEL

	EL_MODULE_STRING_8

	EL_SHARED_SINGLETONS

create
	make

feature {NONE} -- Initialization

	make (type_list: EL_TUPLE_TYPE_LIST [EL_SUB_APPLICATION]; a_select_first: BOOLEAN)
		do
			put_singleton (Current)
			make_list (type_list.count)
			select_first := a_select_first
			create installable_list.make (5)
			across type_list as type loop
				if attached {EL_SUB_APPLICATION} Eiffel.new_instance_of (type.item.type_id) as app then
					extend (app)
					if attached {EL_INSTALLABLE_SUB_APPLICATION} app as installable_app then
						installable_list.extend (installable_app)
					end
				end
			end
			compare_objects
		end

feature -- Access

	installable_list: EL_ARRAYED_LIST [EL_INSTALLABLE_SUB_APPLICATION]

	main: EL_INSTALLABLE_SUB_APPLICATION
		-- main installable application
		require
			has_main_application: has_main
		local
			found_app: BOOLEAN
		do
			across installable_list as app until found_app loop
				if app.item.is_main then
					Result := app.item
					found_app := True
				end
			end
		end

	uninstaller: EL_STANDARD_UNINSTALL_APP
		require
			has_uninstall: has_uninstaller
		local
			l_found: BOOLEAN
		do
			across installable_list as installable until l_found loop
				if attached {EL_STANDARD_UNINSTALL_APP} installable.item as app then
					Result := app
				end
			end
		end

	uninstall_script: EL_UNINSTALL_SCRIPT_I
		require
			has_uninstall: has_uninstaller
			has_main: has_main
		do
			create {EL_UNINSTALL_SCRIPT_IMP} Result.make
		end

	Main_launcher: EL_DESKTOP_MENU_ITEM
		require
			has_main_application: has_main
		once
			if attached {EL_MENU_DESKTOP_ENVIRONMENT_I} main.desktop as main_app_installer then
				Result := main_app_installer.launcher
			else
				create Result.make_default
			end
		end

feature -- Basic operations

	io_put_menu (lio: EL_LOGGABLE)
		do
			lio.put_new_line
			across Current as app loop
				lio.put_labeled_string (app.cursor_index.out + ". command switch", "-" + app.item.option_name)
				lio.tab_right
				lio.put_new_line
				lio.put_string_field_to_max_length ("Description", app.item.description, 300)
				lio.tab_left
				lio.put_new_line
			end
		end

	install_menus
		do
			if has_uninstaller and has_main then
				uninstall_script.serialize
			end
			across installable_list as app loop
				app.item.install
			end
		end

	find (lio: EL_LOGGABLE; name: ZSTRING)
			-- find sub-application with `name' or else user selected application
		do
			find_first_true (agent {EL_SUB_APPLICATION}.is_same_option (name))
			if after then
				if select_first then
					start
				elseif Args.has_silent then
					lio.put_labeled_substitution ("ERROR", "Cannot find sub-application option %"%S%"", [name])
				else
					io_put_menu (lio)
					go_i_th (user_selection)
				end
			end
		end

feature -- Status query

	has_main: BOOLEAN
		-- `True' if has a main installable sub-application
		do
			Result := installable_list.there_exists (agent {EL_INSTALLABLE_SUB_APPLICATION}.is_main)
		end

	has_uninstaller: BOOLEAN
		-- `True' if there is a standard uninstaller
		do
			Result := across installable_list as installable some
				attached {EL_STANDARD_UNINSTALL_APP} installable.item
			end
		end

	select_first: BOOLEAN
		-- if `True' first application selected by default

feature -- Removal

	make_empty
		do
			Precursor
			create installable_list.make_empty
		end

feature {NONE} -- Implementation

	user_selection: INTEGER
			-- Number selected by user from menu
		do
			io.put_string ("Select program by number: ")
			io.read_line
			if io.last_string.is_integer then
				Result := io.last_string.to_integer
			end
		end

feature -- Constants

	Tab_width: INTEGER = 3

end
