note
	description: "Summary description for {RBOX_SYNC_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-02 15:33:35 GMT (Sunday 2nd March 2014)"
	revision: "5"

class
	DEVICE_SYNC_INFO_TABLE

inherit
	HASH_TABLE [EXPORTED_SONG_INFO, NATURAL_64]
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

create
	make_default, make_from_file

feature {NONE} -- Initialization

	make_default
		do
			make_table (7)
			Precursor
		end

	make_from_root_node (root_node: EL_XPATH_ROOT_NODE_CONTEXT)
			--
		local
			song_list: EL_XPATH_NODE_CONTEXT_LIST
			id: NATURAL_64
		do
			song_list := root_node.context_list ("//song")
			accommodate (song_list.count)
			across song_list as song loop
				id := String.hexadecimal_to_natural_64 (song.node.attributes ["id"])
				put (create {like item}.make_from_xpath_context (id, song.node), id)
			end
		end

feature -- Access

	item_path (track_id: NATURAL_64): EL_FILE_PATH
		do
			Result := item (track_id).relative_file_path
		end

	tracks_not_in (other: like Current): ARRAYED_LIST [NATURAL_64]
		do
			create Result.make (50)
			across current_keys as track_id loop
				if not other.has (track_id.item) then
					Result.extend (track_id.item)
				end
			end
		end

	deletion_list (new_sync_info: like Current; updated_songs: ARRAYED_LIST [RBOX_SONG]): ARRAYED_LIST [EL_FILE_PATH]
			-- returns device path list of updated songs and those not in new_sync_info
		do
			create Result.make (updated_songs.count)
			across updated_songs as song loop
				Result.extend (item (song.item.track_id).relative_file_path)
			end
			if new_sync_info /= Current then
				across current_keys as track_id loop
					if not new_sync_info.has (track_id.item) then
						Result.extend (item (track_id.item).relative_file_path)
					end
				end
			end
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
