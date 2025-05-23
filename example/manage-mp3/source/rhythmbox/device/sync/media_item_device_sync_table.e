note
	description: "Media item device sync table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 11:21:23 GMT (Monday 31st March 2025)"
	revision: "17"

class
	MEDIA_ITEM_DEVICE_SYNC_TABLE

inherit
	EL_HASH_TABLE [MEDIA_SYNC_ITEM, STRING]
		rename
			make as make_sized
		end

	EL_XML_FILE_PERSISTENT
		export
			{NONE} all
			{ANY} store, set_output_path, output_path
		undefine
			copy, default_create, is_equal
		redefine
			make_default
		end

	EL_MODULE_LOG

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
		do
			make_equal (7)
			Precursor
		end

	make_from_xdoc (xdoc: EL_XML_DOC_CONTEXT)
			--
		local
			node_list: EL_XPATH_NODE_CONTEXT_LIST; id: STRING
			sg: EL_STRING_GENERAL_ROUTINES
		do
			node_list := xdoc.context_list ("//item")
			accommodate (node_list.count)
			across node_list as l_item loop
				id := l_item.node [Attribute_id]
				sg.super_8 (id).replace_character ('-', ':')
				put (create {like item}.make_from_xpath_context (id, l_item.node), id)
			end
		end

feature -- Access

	deletion_list (new_sync_info: like Current; updated_items: ARRAYED_LIST [MEDIA_ITEM]): ARRAYED_LIST [FILE_PATH]
			-- returns device path list of updated items and those not in new_sync_info
		do
			create Result.make (updated_items.count)
			across updated_items as updated loop
				Result.extend (item (updated.item.id).relative_file_path)
			end
			if new_sync_info /= Current then
				across key_list as id loop
					if not new_sync_info.has (id.item) then
						Result.extend (item (id.item).relative_file_path)
					end
				end
			end
		end

feature -- Query conditions

	exported_item_is_new: EL_PREDICATE_QUERY_CONDITION [MEDIA_ITEM]
		do
			Result := agent not_has_media_item
		end

	exported_item_is_updated: EL_PREDICATE_QUERY_CONDITION [MEDIA_ITEM]
		do
			Result := agent media_item_is_updated
		end

feature {NONE} -- Implementation

	not_has_media_item (media_item: MEDIA_ITEM): BOOLEAN
		do
			Result := not has (media_item.id)
		end

	media_item_is_updated (media_item: MEDIA_ITEM): BOOLEAN
		do
			Result := has_key (media_item.id) and then found_item.checksum /= media_item.checksum
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make_one ("item_list", agent item_list)
		end

feature {NONE} -- Constants

	Attribute_id: STRING_32
		once
			Result := "id"
		end

	Template: STRING = "[
		<?xml version="1.0" encoding="$encoding_name"?>
		<sync-table>
		#foreach $item in $item_list loop
			<item id="$item.id">
			    <location>$item.file_relative_path</location>
			    <checksum>$item.checksum</checksum>
			</item>
		#end
		</sync-table>
	]"

end