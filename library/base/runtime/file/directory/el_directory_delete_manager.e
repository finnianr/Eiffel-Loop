note
	description: "[
		Helper class for ${EL_DIRECTORY} to manage notification of file/directory deletion events
		and cancellation of deletion procedures.
	]"
	notes: "[
		When attached, `internal_on_delete' is called when ever `deleted_list' if full to `capacity'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	EL_DIRECTORY_DELETE_MANAGER

create
	make

feature {NONE} -- Initialization

	make (a_on_delete: like internal_on_delete; a_is_cancel_requested: detachable PREDICATE; capacity: INTEGER)
		do
			internal_is_cancel_requested := a_is_cancel_requested
			if attached a_on_delete and capacity > 0 then
				internal_on_delete := a_on_delete
				create deleted_list.make (capacity)
			else
				deleted_list := Default_list
			end
		end

feature -- Status query

	is_cancel_requested: BOOLEAN
		do
			if attached internal_is_cancel_requested as cancel_requested then
				cancel_requested.apply
				Result := cancel_requested.last_result
			end
		end

feature -- Event handling

	on_delete (a_path: EL_PATH)
		do
			if attached internal_on_delete as l_delete then
				deleted_list.extend (a_path)
				if deleted_list.full then
					l_delete (deleted_list)
					deleted_list.wipe_out
				end
			end
		end

	on_delete_final
		do
			if attached internal_on_delete as l_delete and then not deleted_list.is_empty then
				l_delete (deleted_list)
				deleted_list.wipe_out
			end
		end

feature {NONE} -- Internal attributes

	deleted_list: ARRAYED_LIST [EL_PATH]

	internal_is_cancel_requested: detachable PREDICATE

	internal_on_delete: detachable PROCEDURE [LIST [EL_PATH]]

feature {NONE} -- Constants

	Default_list: ARRAYED_LIST [EL_PATH]
		once
			create Result.make (0)
		end

end