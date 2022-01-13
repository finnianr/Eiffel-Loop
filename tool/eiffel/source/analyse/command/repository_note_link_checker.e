note
	description: "Check for invalid class references in note links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-13 13:02:04 GMT (Thursday 13th January 2022)"
	revision: "8"

class
	REPOSITORY_NOTE_LINK_CHECKER

inherit
	REPOSITORY_PUBLISHER
		redefine
			description, execute
		end

	SHARED_INVALID_CLASSNAMES

create
	make

feature -- Constants

	Description: STRING = "Checks for invalid class references in repository note links"

feature -- Basic operations

	execute
		local
			class_list: EL_STRING_8_LIST
		do
			lio.put_new_line
			lio.put_line ("Checking $source links")
			across ecf_list as tree loop
				lio.put_character ('.')
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						eiffel_class.item.check_class_references
					end
				end
			end
			lio.put_new_line
			across Invalid_source_name_table as table loop
				lio.put_path_field ("Note source link in", table.key)
				lio.put_new_line
				create class_list.make_from_general (table.item)
				lio.put_labeled_string ("Cannot find classes", class_list.joined_with_string (", "))
				lio.put_new_line_x2
			end
		end

end