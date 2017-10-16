note
	description: "Summary description for {MEDIA_ITEM_SYNC_TABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	MEDIA_ITEM_DEVICE_SYNC_TABLE

inherit
	HASH_TABLE [MEDIA_SYNC_ITEM, EL_UUID]
		rename
			make as make_table
		end

	EL_XML_FILE_PERSISTENT
		export
			{NONE} all
			{ANY} store, set_output_path, output_path
		undefine
			is_equal, copy
		redefine
			make_default
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

	EL_QUERY_CONDITION_FACTORY [MEDIA_ITEM]
		undefine
			is_equal, copy
		end

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
		do
			make_equal (7)
			Precursor
		end

	make_from_root_node (root_node: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		local
			node_list: EL_XPATH_NODE_CONTEXT_LIST; id: EL_UUID
		do
			node_list := root_node.context_list ("//item")
			accommodate (node_list.count)
			across node_list as l_item loop
				create id.make_from_string (l_item.node.attributes.string_8 (Attribute_id))
				put (create {like item}.make_from_xpath_context (id, l_item.node), id)
			end
		end

feature -- Access

	deletion_list (new_sync_info: like Current; updated_items: ARRAYED_LIST [MEDIA_ITEM]): ARRAYED_LIST [EL_FILE_PATH]
			-- returns device path list of updated items and those not in new_sync_info
		do
			create Result.make (updated_items.count)
			across updated_items as updated loop
				Result.extend (item (updated.item.id).relative_file_path)
			end
			if new_sync_info /= Current then
				across current_keys as id loop
					if not new_sync_info.has (id.item) then
						Result.extend (item (id.item).relative_file_path)
					end
				end
			end
		end

feature -- Query predicates

	exported_item_is_new: like predicate
		do
			Result := predicate (agent (media_item: MEDIA_ITEM): BOOLEAN
				do
					Result := not has_key (media_item.id)
				end
			)
		end

	exported_item_is_updated: like predicate
		do
			Result := predicate (agent (media_item: MEDIA_ITEM): BOOLEAN
				do
					search (media_item.id)
					Result := found and then found_item.checksum /= media_item.checksum
				end
			)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["item_list", agent: ITERABLE [like item] do Result := linear_representation end]
			>>)
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