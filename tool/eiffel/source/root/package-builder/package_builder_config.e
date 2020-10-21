note
	description: "Build configuration for self-extracting installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-21 13:03:30 GMT (Wednesday 21st October 2020)"
	revision: "2"

class
	PACKAGE_BUILDER_CONFIG

inherit
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS
		rename
			make_from_string as make
		export
			{WINZIP_CREATE_SELF_EXTRACT_COMMAND} field_table
		end

	EL_MODULE_DIRECTORY

create
	make

feature -- Access

	exe_name: STRING

	company: ZSTRING

	install_command: ZSTRING

	product: ZSTRING
		-- product name

	signing_certificate_path: EL_FILE_PATH

feature -- Version

	build: NATURAL

	major: NATURAL

	minor: NATURAL

	release: NATURAL

	version: EL_SOFTWARE_VERSION
		do
			create Result.make_parts (major, minor, release, build)
		end

feature -- wzipse32 arguments

	language: STRING
		-- 'g' or 'e'

	package_ico: EL_FILE_PATH

	text_dialog_message: ZSTRING

	text_install: ZSTRING

	title: ZSTRING

	zipped_package_path: EL_FILE_PATH

feature -- Basic operations

	update (locale: EL_DEFERRED_LOCALE_I)
		-- update arguments for language
		local
			template: WINZIP_TEMPLATE_TEXTS
		do
			create template.make_with_locale (locale)
			text_dialog_message := template.installer_dialog_box #$ [product]
			text_install := template.unzip_installation #$ [product]
			title := template.installer_title #$ [product]
			if locale.language ~ "de" then
				language := "g"
			else
				language := "e"
			end
		end

	increment_build
		do
			build := build + 1
		end

end