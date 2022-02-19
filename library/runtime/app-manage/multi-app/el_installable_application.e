note
	description: "Sub-application that is installable as a system menu item"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 11:36:31 GMT (Saturday 19th February 2022)"
	revision: "12"

deferred class
	EL_INSTALLABLE_APPLICATION

inherit
	EL_ZSTRING_CONSTANTS

	EL_MODULE_IMAGE_PATH

	EL_APPLICATION_CONSTANTS

feature -- Access

	desktop: EL_DESKTOP_ENVIRONMENT_I
		deferred
		end

	desktop_launcher: EL_DESKTOP_MENU_ITEM
		deferred
		end

	desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		deferred
		end

	name: ZSTRING
		-- short name for application
		-- The default is a propercase name derived from `generator' name with any "APP" suffix removed
		local
			words: EL_ZSTRING_LIST
		do
			create words.make_split (generator, '_')
			words.finish
			if not words.off and then words.item.same_string ("APP") then
				words.remove
			end
			Result := words.joined_propercase_words
		end

	input_path_option: STRING
		-- default input path option -file
		do
			Result := Standard_option.file
		end

	option_name: READABLE_STRING_GENERAL
		deferred
		end

	unwrapped_description: ZSTRING
		deferred
		end

feature -- Basic operations

	install
		local
			l_desktop: like desktop
		do
			l_desktop := desktop
			l_desktop.install
		end

	uninstall
			--
		local
			l_desktop: like desktop
		do
			l_desktop := desktop
			l_desktop.uninstall
		end

feature -- Factory routines

	new_application_mutex: EL_APPLICATION_MUTEX_I
		deferred
		end

feature {NONE} -- Factory

	new_category, new_standard_category (a_name: READABLE_STRING_GENERAL): EL_DESKTOP_MENU_ITEM
		-- new standard category (Applies to Linux, Windows is freeform)
		-- See in /usr/share/desktop-directories
		--
		do
			create Result.make_standard (a_name)
		end

	new_console_app_menu_desktop_environment: EL_CONSOLE_APP_MENU_DESKTOP_ENV_I
			-- new desktop environment for a console application (no-GUI)
		do
			create {EL_CONSOLE_APP_MENU_DESKTOP_ENV_IMP} Result.make (Current)
		end

	new_context_menu_desktop (menu_path: READABLE_STRING_GENERAL): EL_FILE_CONTEXT_MENU_DESKTOP_ENV_I
		do
			create {EL_FILE_CONTEXT_MENU_DESKTOP_ENV_IMP} Result.make (Current, menu_path)
		end

	new_custom_category (a_name, a_comment: READABLE_STRING_GENERAL; icon_path: FILE_PATH): EL_DESKTOP_MENU_ITEM
		-- new custom category
		-- See: https://standards.freedesktop.org/menu-spec/latest/apa.html
		do
			if icon_path.is_absolute then
				create Result.make (a_name, a_comment, icon_path)
			else
				create Result.make (a_name, a_comment, Image_path.desktop_menu_icon (icon_path))
			end
		end

	new_launcher (icon_path: FILE_PATH): EL_DESKTOP_MENU_ITEM
		-- new launcher
		do
			if icon_path.is_absolute then
				create Result.make (name, unwrapped_description, icon_path)
			else
				create Result.make (name, unwrapped_description, Image_path.desktop_menu_icon (icon_path))
			end
		end

	new_menu_desktop_environment: EL_MENU_DESKTOP_ENVIRONMENT_I
			--
		do
			create {EL_MENU_DESKTOP_ENVIRONMENT_IMP} Result.make (Current)
		end

feature {NONE} -- Defaults

	Default_desktop_launcher: EL_DESKTOP_MENU_ITEM
		once
			create Result.make_default
		end

	Default_desktop_menu_path: ARRAY [EL_DESKTOP_MENU_ITEM]
		once
			create Result.make_empty
		end

	Default_desktop: EL_DEFAULT_DESKTOP_ENVIRONMENT
		once
			create Result.make_default
		end

end