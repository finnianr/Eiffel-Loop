note
	description: "Check for invalid class references in note links"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
			tree_list.do_all (agent {REPOSITORY_SOURCE_TREE}.read_source_files)
			across tree_list as tree loop
				across tree.item.directory_list as directory loop
					across directory.item.class_list as eiffel_class loop
						eiffel_class.item.check_class_references
					end
				end
			end
		end

end
