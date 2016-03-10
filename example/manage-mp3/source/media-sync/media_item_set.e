note
	description: "Summary description for {MEDIA_ITEM_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-24 13:24:49 GMT (Monday 24th June 2013)"
	revision: "2"

class
	MEDIA_ITEM_SET [I -> MEDIA_ITEM create make end]

inherit
	HASH_TABLE [I, MEDIA_ITEM_KEY]
		rename
			make as make_set,
			put as put_item,
			linear_representation as linear_item_representation,
			item as key_item,
			item_for_iteration as item,
			remove as remove_key
		export
			{NONE} all
			{ANY} start, after, count, forth, item, found_item, found, has, search
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

create
	make, make_with_filter

feature {NONE} -- Initialization

	make (a_root_path: like root_path; a_media_type: STRING)
			--
		do
			make_with_filter (a_root_path, a_media_type, agent (path: EL_PATH): BOOLEAN do Result := true end )
		end

	make_with_filter (a_root_path: like root_path; a_media_type: STRING; filter_agent: PREDICATE [ANY, TUPLE [EL_PATH]])
			--
		local
			file_list: EL_FILE_PATH_LIST
			media_item: I
		do
			media_type := a_media_type
			root_path := a_root_path
			create file_list.make (root_path, "*." + media_type)
			make_set (file_list.count)
			compare_objects

			from file_list.start until file_list.after loop
				if filter_agent.item ([file_list.path]) then
					create media_item.make (file_list.path, root_path)
					put (media_item)
				end
				file_list.forth
			end
		end

feature -- Access

	media_type: STRING

	root_path: EL_DIR_PATH

feature -- Conversion

	linear_representation: ARRAYED_LIST [like item]
			-- Representation as a linear structure
		local
			old_iteration_position: INTEGER
		do
			old_iteration_position := iteration_position
			create Result.make (count)
			from start until after loop
				Result.extend (item)
				forth
			end
			iteration_position := old_iteration_position
		end

feature -- Element change

	put (member: I)
			--
		do
			put_item (member, member.key)
		end

feature -- Removal

	remove (member: I)
			--
		do
			remove_key (member.key)
		end

feature {NONE} -- Implementation

	include_item (media_item: I): BOOLEAN
			--
		do
			Result := true
		end


end
