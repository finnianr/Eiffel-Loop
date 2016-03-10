note
	description: "Summary description for {RBOX_SYNC_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-27 12:58:16 GMT (Sunday 27th October 2013)"
	revision: "4"

class
	RBOX_SYNC_INFO_TABLE

inherit
	HASH_TABLE [RBOX_SYNC_INFO, NATURAL_64]
		rename
			make as make_table
		end

	EL_XML_FILE_PERSISTENT
		export
			{NONE} all
			{ANY} store
		undefine
			is_equal, copy
		redefine
			make
		end

	EL_MODULE_LOG
		undefine
			is_equal, copy
		end

create
	make, make_from_file

feature {NONE} -- Initialization

	make
		do
			make_table (7)
			encoding_name := "UTF-8"
			Precursor
		end

	make_from_root_node (root_node: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		local
			song_list: EL_XPATH_NODE_CONTEXT_LIST
			id: NATURAL_64
		do
--			Build object from xml file if it exists
			song_list := root_node.context_list ("//song")
			accommodate (song_list.count)
			across song_list as song loop
				id := String.hexadecimal_to_natural_64 (song.node.attributes ["id"])
				put (create {like item}.make_from_xpath_context (id, song.node), id)
			end
		end

feature -- Access

	item_path (exported_path: EL_DIR_PATH; track_id: NATURAL_64): EL_FILE_PATH
		do
			Result := exported_path + item (track_id).file_relative_path
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["songs", agent: ITERABLE [like item] do Result := linear_representation end]
			>>)
		end

feature {NONE} -- Constants

	Template: STRING = "[
		<?xml version="1.0" encoding="$encoding_name"?>
		<rhythmdb-synchronization>
		#foreach $item in $songs loop
			<song id="$item.id">
			    <location>$item.file_relative_path</location>
			    <checksum>$item.checksum</checksum>
			</song>
		#end
		</rhythmdb-synchronization>
	]"

end
