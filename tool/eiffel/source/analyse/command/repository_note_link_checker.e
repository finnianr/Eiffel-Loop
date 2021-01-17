note
	description: "Check for invalid class references in note links"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-17 15:31:07 GMT (Sunday 17th January 2021)"
	revision: "4"

class
	REPOSITORY_NOTE_LINK_CHECKER

inherit
	REPOSITORY_PUBLISHER
		redefine
			execute
		end

create
	make

feature -- Basic operations

	execute
		do
			log_thread_count
			ecf_list.do_all (agent {EIFFEL_CONFIGURATION_FILE}.read_source_files (parser))
			across ecf_list as tree loop
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						eiffel_class.item.check_class_references
					end
				end
			end
		end

end