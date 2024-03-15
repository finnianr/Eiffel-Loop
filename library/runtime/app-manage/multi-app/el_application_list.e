note
	description: "List of sub-applications"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-03-15 9:25:49 GMT (Friday 15th March 2024)"
	revision: "28"

class
	EL_APPLICATION_LIST

inherit
	EL_ARRAYED_LIST [EL_APPLICATION]
		rename
			make as make_list
		export
			{EL_MULTI_APPLICATION_ROOT} make_empty
		redefine
			initialize
		end

	EL_SOLITARY
		rename
			make as make_solitary
		end

	EL_MODULE_ARGS

	EL_MODULE_EIFFEL

	EL_SHARED_BASE_OPTION

create
	make

feature {NONE} -- Initialization

	make (type_list: EL_TUPLE_TYPE_LIST [EL_APPLICATION])
		do
			make_list (type_list.count)
			append_types (type_list)
		ensure
			at_most_one_main_application: count_of (agent is_main) <= 1
		end

	initialize
		do
			Precursor
			make_solitary
			create installable_list.make (5)
			compare_objects
		end

feature -- Access

	Main_launcher: EL_DESKTOP_MENU_ITEM
		require
			has_main_application: has_main
		once
			if attached main as main_app
				and then attached {EL_MENU_DESKTOP_ENVIRONMENT_I} main_app.desktop as main_app_installer then
				Result := main_app_installer.launcher
			else
				create Result.make_default
			end
		end

	application (type: TYPE [EL_APPLICATION]): detachable EL_APPLICATION
		do
			across Current as app until attached Result loop
				if app.item.generating_type ~ type then
					Result := app.item
				end
			end
		end

	installable_list: EL_ARRAYED_LIST [EL_INSTALLABLE_APPLICATION]

	main: detachable EL_INSTALLABLE_APPLICATION
		-- main installable application
		do
			push_cursor
			find_first_true (agent is_main)
			if attached {EL_INSTALLABLE_APPLICATION} item as main_app then
				Result := main_app
			end
			pop_cursor
		end

	uninstall_app: detachable EL_STANDARD_UNINSTALL_APP
		do
			across installable_list as installable until attached Result loop
				if attached {EL_STANDARD_UNINSTALL_APP} installable.item as app then
					Result := app
				end
			end
		end

	uninstall_script: detachable EL_UNINSTALL_SCRIPT_I
		require
			has_main: has_main
		do
			if attached uninstall_app as app then
				create {EL_UNINSTALL_SCRIPT_IMP} Result.make (app)
			end
		end

feature -- Basic operations

	find (lio: EL_LOGGABLE; name: ZSTRING)
			-- if `count = 1' go to first app
			-- 	or else find sub-application with `is_same_option (name)'
			--		or else find `main' application
			-- 	or go to user selected application
		do
			if count = 1 then
				go_i_th (1)
			else
				find_first_true (agent {EL_APPLICATION}.is_same_option (name))
				if after then
					find_first_true (agent is_main)

					if after then
						if name.is_empty then
							io_put_menu (lio)
							go_i_th (user_selection)
						elseif not Base_option.silent then
							lio.put_labeled_substitution ("ERROR", "Cannot find sub-application option %"%S%"", [name])
						end
					end
				end
			end
		end

	install_menus
		do
			if has_main and then attached uninstall_script as script then
				script.serialize
			end
			across installable_list as app loop
				app.item.install
			end
		end

	io_put_menu (lio: EL_LOGGABLE)
		do
			lio.put_new_line
			across Current as app loop
				lio.put_labeled_string (app.cursor_index.out + ". command switch", "-" + app.item.option_name)
				lio.put_new_line
				lio.put_labeled_lines ("Description", app.item.description.split ('%N'))
				lio.put_new_line
			end
		end

	uninstall
		do
			across installable_list as app loop
				app.item.uninstall
			end
			if has_main and then attached uninstall_script as script then
				script.create_remove_directories_script
			end
		end

feature -- Status query

	has_main: BOOLEAN
		-- `True' if has a main installable sub-application
		do
			push_cursor
			find_first_true (agent is_main)
			Result := not after
			pop_cursor
		end

	has_uninstaller: BOOLEAN
		-- `True' if there is a standard uninstaller
		do
			Result := attached uninstall_app
		end

feature -- Element change

	append_types (type_list: EL_TUPLE_TYPE_LIST [EL_APPLICATION])
		do
			grow (count + type_list.count)
			across type_list as type loop
				if attached {EL_APPLICATION} Eiffel.new_instance_of (type.item.type_id) as app then
					extend (app)
					if attached {EL_INSTALLABLE_APPLICATION} app as installable_app then
						installable_list.extend (installable_app)
					end
				end
			end
		end

feature {NONE} -- Implementation

	is_main (app: EL_APPLICATION): BOOLEAN
		do
			Result := attached {EL_MAIN_INSTALLABLE_APPLICATION} app
		end

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