note
	description: "Check for invalid class references in note links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-11-23 13:33:03 GMT (Tuesday 23rd November 2021)"
	revision: "5"

class
	REPOSITORY_NOTE_LINK_CHECKER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute
		end

	SHARED_INVALID_CLASSNAMES

create
	make

feature -- Basic operations

	execute
		local
			class_list: EL_STRING_8_LIST
		do
			lio.put_line ("Checking")
			across ecf_list as tree loop
				lio.put_character ('.')
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						eiffel_class.item.check_class_references
					end
				end
			end
			lio.put_new_line
			across Invalid_classname_map.new_grouped_table as table loop
				lio.put_path_field ("Note source link in", table.key)
				lio.put_new_line
				create class_list.make_from_general (table.item)
				lio.put_labeled_string ("Cannot find classes", class_list.joined_with_string (", "))
				lio.put_new_line_x2
			end
		end

end
