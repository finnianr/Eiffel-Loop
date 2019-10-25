note
	description: "Id3 info i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 11:59:06 GMT (Thursday   10th   October   2019)"
	revision: "7"

deferred class
	ID3_INFO_I

inherit
	ANY
		redefine
			default_create
		end

	ID3_MODULE_TAG

feature -- Initialization

	default_create
		do
			create mp3_path
			create frame_list.make (0)
		end

	make
   		--
   	deferred
   	end

feature -- Access

	frame_count: INTEGER
		deferred
		end

	frame_list: EL_ARRAYED_LIST [ID3_FRAME]

	mp3_path: EL_FILE_PATH

feature -- Element change

	detach (field: ID3_FRAME)
			--
		deferred
		end

	link (a_mp3_path: like mp3_path)
		-- link file without reading tags
		deferred
		end

	link_and_read (a_mp3_path: like mp3_path)
		deferred
		end

	set_version (a_version: REAL)
		deferred
		end

feature -- File writes

	strip_v1
			--
		deferred
		end

	strip_v2
			--
		deferred
		end

	update
			--
		deferred
		end

	update_v1
			--
		deferred
		end

	update_v2
			--
		deferred
		end

feature -- Removal

	prune (frame: ID3_FRAME)
				-- Remove field frame
		do
			frame_list.prune (frame); detach (frame)
		end

	wipe_out
			--
		deferred
		end

feature -- Factory

	new_album_picture_frame (a_picture: ID3_ALBUM_PICTURE): ID3_ALBUM_PICTURE_FRAME
		deferred
		end

	new_field (an_id: STRING): ID3_FRAME
			--
		deferred
		end

	new_unique_file_id_field (owner_id: ZSTRING; an_id: STRING): ID3_UNIQUE_FILE_ID_FRAME
			--
		deferred
		end

feature {ID3_INFO} -- Implementation

	dispose
		deferred
		end

end
