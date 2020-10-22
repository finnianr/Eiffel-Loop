note
	description: "Build configuration for self-extracting installer"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-10-22 10:09:51 GMT (Thursday 22nd October 2020)"
	revision: "3"

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

	company: ZSTRING

	exe_name: STRING

	install_command: ZSTRING

	package_name_template: ZSTRING

	product: ZSTRING
		-- product name

	signing_certificate_path: EL_FILE_PATH

	time_stamp_url: STRING

feature -- Version

	build: NATURAL

	major: NATURAL

	minor: NATURAL

	release: NATURAL

	version: EL_SOFTWARE_VERSION
		do
			create Result.make_parts (major, minor, release, build)
		end

feature -- Status query

	valid_package_name_template: BOOLEAN
		do
			Result := package_name_template.ends_with_general (".exe")
							and then (2 |..| 3).has (package_name_template.occurrences ('%S'))
		end

feature -- wzipse32 arguments

	language: STRING
		-- 'g' or 'e'

	package_ico: EL_FILE_PATH

	text_dialog_message: ZSTRING

	text_install: ZSTRING

	title: ZSTRING

	zip_archive_path: EL_FILE_PATH

feature -- sign tool arguments

	exe_path: EL_FILE_PATH

	pass_phrase: STRING

feature -- Basic operations

	increment_build
		do
			build := build + 1
		end

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

feature -- Element change

	set_exe_path (a_exe_path: like exe_path)
		do
			exe_path := a_exe_path
		end

	set_pass_phrase (a_pass_phrase: STRING)
		do
			pass_phrase := a_pass_phrase
		end

	set_zip_archive_path (a_zip_archive_path: EL_FILE_PATH)
		do
			zip_archive_path := a_zip_archive_path
		end

end