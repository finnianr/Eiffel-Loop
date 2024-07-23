note
	description: "Localization texts for application install/uninstall"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-23 9:21:52 GMT (Tuesday 23rd July 2024)"
	revision: "9"

class
	EL_INSTALL_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			title_case_texts
		end

	EL_MODULE_BUILD_INFO

create
	make

feature -- Access

	install_title: ZSTRING
		do
			Result := install_title_template #$ [Build_info.product]
		end

	newer_version (version: EL_SOFTWARE_VERSION): ZSTRING
		do
			Result := newer_version_template #$ [Build_info.product, version.string]
		end

	setup_title: ZSTRING
		do
			Result := setup_title_template #$ [Build_info.product]
		end

	unable_to_connect (domain_name, email: ZSTRING): ZSTRING
		do
			Result := unable_to_connect_template #$ [domain_name, email]
		end

	version_title (version: EL_SOFTWARE_VERSION): ZSTRING
		do
			Result := version_template #$ [Build_info.product, version.string]
		end

feature -- Templates

	matching_instruction_template: ZSTRING

	newer_version_template: ZSTRING

	setup_title_template: ZSTRING

	install_title_template: ZSTRING

	unable_to_connect_template: ZSTRING

	version_template: ZSTRING

feature -- Phrases

	A5_tip: ZSTRING

	size_template: ZSTRING

	contacting_server: ZSTRING

	close_uninstall: ZSTRING

	installing_files: ZSTRING

	installation_complete: ZSTRING

	landscape_orientation: ZSTRING

	uninstall_proceed: ZSTRING

	web_connection_error: ZSTRING

feature -- Words

	finish: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				a5_tip:
					TIP: If you don't have an A5 sheet, fold an A4 size in two.
					It works the same.
				close_uninstall:
					Close to complete uninstall
				install_title_template:
					%S Installation
				matching_instruction_template:
					Place a sheet of %S paper over this window and
					then use the mouse to drag the edges of the
					window until the sizes match exactly.
					
					This adjustment will allow the size of your
					display to be accurately determined and ensure
					that the application text and graphics are
					displayed at the correct size.
				newer_version_template:
					A newer version of %S is available.
					Please consider downloading version %S
				setup_title_template:
					%S Geometry Setup
				size_template:
					(%S cm x %S cm)
				unable_to_connect_template:
					Unable to connect to http://%S
					The site may be down. Please try again later.
					
					If you think we have failed to notice, please
					send an email to %S
				uninstall_proceed:
					Are you sure you wish to proceed with uninstall?
				version_template:
					%S Version %S
			]"
		end

	title_case_texts: like None
		-- English key texts that are entirely title case (First letter of each word capatilized)
		do
			Result := << web_connection_error >>
		end

end