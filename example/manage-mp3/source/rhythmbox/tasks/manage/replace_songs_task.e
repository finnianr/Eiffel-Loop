note
	description: "Replace songs task"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-31 14:14:17 GMT (Tuesday 31st March 2020)"
	revision: "4"

class
	REPLACE_SONGS_TASK

inherit
	RBOX_MANAGEMENT_TASK

	DATABASE_UPDATE_TASK

create
	make

feature -- Basic operations

	apply
		local
			substitution_list: like new_substitution_list
		do
			log.enter ("apply")
			substitution_list := new_substitution_list
			across substitution_list as substitution loop
				if substitution.item.deleted_path /~ substitution.item.replacement_path
					and then across << substitution.item.deleted_path, substitution.item.replacement_path >> as path all
						Database.songs_by_location.has (path.item)
					end
				then
					Database.replace (substitution.item.deleted_path, substitution.item.replacement_path)
					Database.remove (Database.songs_by_location [substitution.item.deleted_path])
					OS.delete_file (substitution.item.deleted_path)
				else
					lio.put_line ("INVALID SUBSTITUTION")
					lio.put_path_field ("Target", substitution.item.deleted_path)
					lio.put_new_line
					lio.put_path_field ("Replacement", substitution.item.replacement_path)
					lio.put_new_line
				end
			end
			if not substitution_list.is_empty then
				Database.store_all
			end
			log.exit
		end

feature {NONE} -- Factory

	new_substitution: TUPLE [deleted_path, replacement_path: EL_FILE_PATH]
		do
			create Result
			Result.deleted_path := User_input.file_path ("Song to remove")
			lio.put_new_line
			Result.replacement_path := User_input.file_path ("Song replacement")
			lio.put_new_line
		end

	new_substitution_list: LINKED_LIST [like new_substitution]
		local
			done: BOOLEAN
		do
			create Result.make
			from until done loop
				Result.extend (new_substitution)
				done := Result.last.deleted_path.is_empty and Result.last.replacement_path.is_empty
			end
			Result.finish
			Result.remove
		end

end
