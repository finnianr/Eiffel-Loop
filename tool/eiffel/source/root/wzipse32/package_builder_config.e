note
	description: "Build configuration for self-extracting installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-19 13:47:46 GMT (Monday 19th October 2020)"
	revision: "1"

class
	PACKAGE_BUILDER_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_file as make
		export
			{WINZIP_CREATE_SELF_EXTRACT_COMMAND} field_table
		end

	EL_MODULE_DIRECTORY

create
	make

feature -- Access

	application_name: ZSTRING

	install_command: ZSTRING

feature -- wzipse32 arguments

	language: STRING
		-- 'g' or 'e'

	text_dialog_message: ZSTRING

	text_install: ZSTRING

	title: ZSTRING

	package_ico: EL_FILE_PATH

	zipped_package_path: EL_FILE_PATH

feature -- Basic operations

	update (locale: EL_DEFERRED_LOCALE_I)
		-- update arguments for language
		local
			template: WINZIP_TEMPLATE_TEXTS
		do
			create template.make_with_locale (locale)
			text_dialog_message := template.installer_dialog_box #$ [application_name]
			text_install := template.unzip_installation #$ [application_name]
			title := template.installer_title #$ [application_name]
			if locale.language ~ "de" then
				language := "g"
			else
				language := "e"
			end
		end

end