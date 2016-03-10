note
	description: "[
		Updates Linux packages by reading output of apt-rdepends from stdin
		Calls apt-get to reinstall each package
		
		See: http://www.debianadmin.com/recursively-lists-package-dependencies-using-apt-rdepends.html
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 17:06:08 GMT (Thursday 25th July 2013)"
	revision: "3"

class
	DEPENDENCY_INSTALLER_APP

inherit
	EL_SUB_APPLICATION
		redefine
			Option_name
		end
create
	make

feature {NONE} -- Initialization

	initialize
			--
		do
			Args.set_string_from_word_option ("file_in", agent set_input_file, Standard_input)
			create dependency_installer.make
		end

feature -- Basic operations

	run
			--
		do
			dependency_installer.set_source_text_from_line_source (input_file)
			dependency_installer.install_dependencies
			input_file.close
		end

feature -- Element change

	set_input_file (a_file_path: EL_ASTRING)
			--
		do
 			if a_file_path = Standard_input then
				input_file := io.input
			else
	 			create input_file.make_open_read (a_file_path.to_unicode)
 			end
		end

feature {NONE} -- Implementation

	input_file: PLAIN_TEXT_FILE

	dependency_installer: DEPENDENCY_INSTALLER

feature {NONE} -- Constants

	Standard_input: STRING = "stdout"

	Option_name: STRING = "apt_get_update"

	Description: STRING = "Updates Linux packages by reading output of apt-rdepends"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{DEPENDENCY_INSTALLER_APP}, "*"],
				[{DEPENDENCY_INSTALLER}, "*"]
			>>
		end

end
