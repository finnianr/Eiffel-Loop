note
	description: "Localization texts for application install/uninstall"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-03-01 17:45:13 GMT (Tuesday 1st March 2022)"
	revision: "4"

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

	A5_instructions: EL_ZSTRING_LIST
		local
			s: EL_ZSTRING_ROUTINES
		do
			Result := s.New_paragraph_list (A5_instructions_template #$ [Build_info.product])
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

	A5_instructions_template: ZSTRING

	newer_version_template: ZSTRING

	setup_title_template: ZSTRING

	unable_to_connect_template: ZSTRING

	version_template: ZSTRING

feature -- Phrases

	a5_dimensions: ZSTRING

	close_uninstall: ZSTRING

	installing_files: ZSTRING

	installation_complete: ZSTRING

	uninstall_proceed: ZSTRING

	web_connection_error: ZSTRING

feature -- Words

	finish: ZSTRING

feature {NONE} -- Implementation

	english_table: STRING
		do
			Result := "[
				a5_dimensions:
					(21 cm x 14.8 cm)
				a5_instructions_template:
					Place a sheet of A5 paper over this window and
					then use the mouse to drag the edges of the
					window until the sizes match exactly. (Or you
					can fold an A4 sheet in two)
					
					This adjustment will allow the size of your
					display to be accurately determined and ensure
					that the application text and graphics are 
					displayed at the correct size.
					
					Note that the %S application window
					is considerably bigger than A5 paper.
				close_uninstall:
					Close to complete uninstall
				newer_version_template:
					A newer version of %S is available.
					Please consider downloading version %S
				setup_title_template:
					%S Setup
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