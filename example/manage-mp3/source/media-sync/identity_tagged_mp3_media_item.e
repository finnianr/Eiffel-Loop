note
	description: "Summary description for {IDENTITY_TAGGED_MP3_MEDIA_ITEM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-15 15:51:21 GMT (Saturday 15th June 2013)"
	revision: "2"

class
	IDENTITY_TAGGED_MP3_MEDIA_ITEM

inherit
	UNIQUELY_IDENTIFIABLE_MEDIA_ITEM
		redefine
			make
		end

	SHARED_MEDIA_SYNC_CONFIGURATION

	EL_MODULE_LOG

	EL_ID3_ENCODINGS

create
	make

feature {NONE} -- Initialization

	make (a_mp3_path: like mp3_path; a_root_path: like root_path)
			--
		local
			id3_tag: EL_ID3_INFO
		do
			log.enter_with_args ("make", << a_mp3_path >>)
			Precursor (a_mp3_path, a_root_path)

			create id3_tag.make (mp3_path)

			if not id3_tag.has_unique_id (media_sync_config.UFID_name) then
				id3_tag.set_unique_id (media_sync_config.UFID_name, "0x" + media_sync_config.unique_file_id.to_hex_string)
				id3_tag.update
				media_sync_config.set_next_unique_file_id
				media_sync_config.store
			end
			unique_id := String.hexadecimal_to_integer (id3_tag.unique_id_for_owner (media_sync_config.UFID_name))
			log.exit
		end

end
