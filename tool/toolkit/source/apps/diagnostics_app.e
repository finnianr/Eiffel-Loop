note
	description: "Diagnose Windows 11 desktop location"
	notes: "el_toolkit -diagnostics"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-07 10:43:07 GMT (Friday 7th October 2022)"
	revision: "1"

class
	DIAGNOSTICS_APP

inherit
	EL_APPLICATION

feature {NONE} -- Initialization

	initialize
		do
		end

feature -- Basic operations

	run
		do
			lio.put_labeled_string ("Home", Directory.home)
			lio.put_new_line
			across << Directory.desktop, Directory.desktop_common >> as desktop loop
				lio.put_path_field ("XML files", desktop.item)
				lio.put_new_line
				across File_system.files_with_extension (desktop.item, "xml", False) as path loop
					lio.put_path_field (path.cursor_index.out, path.item)
					lio.put_new_line
				end
				lio.put_new_line
			end
		end

feature {NONE} -- Constants

	Description: STRING = "Diagnose Windows 11 desktop location"
end