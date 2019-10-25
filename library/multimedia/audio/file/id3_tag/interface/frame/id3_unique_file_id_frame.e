note
	description: "Id3 unique file id"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 14:09:24 GMT (Thursday   10th   October   2019)"
	revision: "7"

deferred class
	ID3_UNIQUE_FILE_ID_FRAME

inherit
	ID3_FRAME
		rename
			code as field_id
		end

	ID3_MODULE_TAG

feature {NONE} -- Initialization

	make (owner_id: like owner; an_id: like id)
			--
		do
			make_new (Tag.Unique_file_ID)
			set_owner (owner_id)
			set_id (an_id)
		end

feature -- Access

	owner: ZSTRING
			--
		require
			valid_field_id: has_owner_field
		do
        	Result := string
		end

	id: STRING
			-- unique id
		require
			valid_field_id: has_data_field
		do
			Result := data_string
		end

feature -- Status query

	has_owner_field: BOOLEAN
		do
			Result := field_list.has_type (Field_type.string)
		end

	has_data_field: BOOLEAN
		do
			Result := field_list.has_type (Field_type.binary_data)
		end

feature -- Element change

	set_owner (owner_id: ZSTRING)
			--
		require
			valid_field_id: has_owner_field
		do
			set_string (owner_id)
		end

	set_id (an_id: STRING)
			--
		require
			valid_field_id: has_data_field
		do
			set_data_string (an_id)
		end

end
