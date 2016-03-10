note
	description: "Summary description for {EL_EYED3_TAG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EYED3_TAG

inherit
	EL_PYTHON_SELF

	EL_EYED3_VERSION_CONSTANTS

create
	make, make_new

feature {NONE} -- Initialization

	make (file_path: STRING)
			-- Make from existing tag
		do
			import_eyed3
			make_self (Python.item ("eyeD3.Tag", []))
			self.call ( "link", [file_path])
			is_file_linked := Python.is_last_operation_ok
		end

	make_new (file_path: STRING; an_id3_version: INTEGER)
			-- Make new tag
		do
			import_eyed3
			make_self (Python.item ("eyeD3.Tag", [file_path]))
			self.call ("header.setVersion", [an_id3_version])

			is_file_linked := Python.is_last_operation_ok
		end

feature -- Access

	unique_id (owner_id: STRING): STRING
			--
		local
			i: INTEGER
			unique_file_id: EL_PYTHON_OBJECT
		do
			Result := "0x0"
			if attached {PYTHON_LIST} self.item ("getUniqueFileIDs", []) as unique_file_id_list then
				from i := 0 until i >= unique_file_id_list.size loop
					unique_file_id := unique_file_id_list.item_at (i)
					if owner_id ~ unique_file_id.string_attribute ("owner_id") then
						Result := unique_file_id.string_attribute ("id")
					end
					i := i + 1
				end
			end
		end

	ID3_version: INTEGER
			--
		do
			Result := self.integer_item ("getVersion", [])
		end

	title: STRING
			--
		do
			Result := self.ustring_item ("getTitle", [])
		end

	artist: STRING
			--
		do
			Result := self.ustring_item ("getArtist", [])
		end

	album: STRING
			--
		do
			Result := self.ustring_item ("getAlbum", [])
		end

	genre: STRING
			--
		do
			Result := self.ustring_item ("getGenre().getName", [])
		end

	year: INTEGER
			--
		do
			Result := self.string_item ("getYear", []).to_integer
		end

feature -- Status report

	is_file_linked: BOOLEAN

feature -- Element change

	set_id3_version, update (version: INTEGER)
			--
		require
			is_file_linked: is_file_linked
			is_valid_version: (Valid_ID3_versions).has (version)
		do
			self.call ("update", [version])
		end

	set_id3_unique_id (owner_id, hex_string: STRING)
			--
		do
			self.call ("addUniqueFileID", [owner_id, hex_string] )
		end

	set_year (a_year: INTEGER)
			--
		do
			self.call ("setDate", [a_year])
		end

	set_artist (an_artist: STRING)
			--
		do
			self.call ("setArtist", [an_artist])
		end

	set_title (a_title: STRING)
			--
		do
			self.call ("setTitle", [a_title])
		end

	set_album (an_album: STRING)
			--
		do
			self.call ("setAlbum", [an_album])
		end

	set_genre (a_genre: STRING)
			--
		do
			set_text_frame (Content_type, a_genre)
		end

	set_text_frame (name, value: STRING)
			--
		do
			self.call ("setTextFrame", [name, value])
		end

feature {NONE} -- Implementation

	import_eyeD3
			--
		once
			Python.import_module ("eyeD3")
		end

feature {NONE} -- Implementation

	Content_type: STRING = "TCON"

invariant
	linked_to_file: is_file_linked

end
