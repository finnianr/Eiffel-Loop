note
	description: "Thunderbird email headers and content reflectively settable from ${STRING_8} lines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:37 GMT (Sunday 22nd September 2024)"
	revision: "17"

class
	TB_EMAIL

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as kebab_case_title,
			field_included as is_any_field,
			make_default as make
		redefine
			new_tuple_field_table, new_representations
		end

	EL_SETTABLE_FROM_STRING_8
		rename
			make_default as make
		end

	EL_MODULE_CONVERT_STRING

	EL_MODULE_ENCODING
		rename
			Encoding as Encoding_
		end

	EL_CHARACTER_8_CONSTANTS

create
	make

feature -- Access

	content_encoding: NATURAL
		do
			Result := Encoding_.name_to_encoding (content_type.encoding_name)
		end

	mime_version_string: STRING
		do
			Mime_version_type.set_from_compact (mime_version)
			Result := Mime_version_type.out
		end

	modification_time: EL_DATE_TIME
		do
			create Result.make_from_epoch (date)
		end

	subject_decoded: ZSTRING
		do
			Result := Subject_decoder.decoded (subject)
		end

feature -- Thunderbird fields

	FCC: STRING

	from_: STRING

	content: ZSTRING

	content_type: TUPLE [mime, encoding_name: STRING]
		-- Eg. text/html; charset=iso-8859-15

	content_transfer_encoding: STRING

	date: INTEGER

	message_id: STRING

	mime_version: NATURAL
		-- Eg. 1.0

	subject: STRING
		-- raw subject line which maybe encoded

	user_agent: STRING

	x_identity_key: STRING

	x_account_key: STRING

	x_mozilla_draft_info: TUPLE [
		type: STRING; vcard, receipt, DSN, uu_encode, attachment_reminder, delivery_format: NATURAL_8
	]
		-- Eg. internal/draft; vcard=0; receipt=0; DSN=0; uuencode=0; attachmentreminder=0; deliveryformat=4

	x_mozilla_keys: STRING

	x_mozilla_status: NATURAL

	x_mozilla_status2: NATURAL

feature {NONE} -- Factories

	new_content_type (str: READABLE_STRING_GENERAL): like Convert_string.split_list
		do
			Result := Convert_string.split_list (str, ';', {EL_SIDE}.Left)
			Result.for_all_remove_up_to ('=')
		end

	new_draft_info (str: READABLE_STRING_GENERAL): like Convert_string.split_list
		local
			zero_fields: STRING; l_count: INTEGER
		do
			l_count := str.occurrences (';') + 1
			if l_count < x_mozilla_draft_info.count then
				zero_fields := "; =0"
				zero_fields.multiply (x_mozilla_draft_info.count - l_count)
				Result := Convert_string.split_list (str + zero_fields, ';', {EL_SIDE}.Left)
			else
				Result := Convert_string.split_list (str, ';', {EL_SIDE}.Left)
			end
			Result.for_all_remove_up_to ('=')
		end

feature {NONE} -- Reflection hints

	new_representations: like Default_representations
		do
			create Result.make_assignments (<<
				["date", Date_representation],
				["content_transfer_encoding", Transfer_encodings.to_representation],
				["mime_version", Mime_version_type.to_representation],
				["x_mozilla_keys", Mozilla_key_set.to_representation]
			>>)
		end

	new_tuple_field_table: like Default_tuple_field_table
		-- agent function to convert `READABLE_STRING_GENERAL' to adjusted `EL_SPLIT_READABLE_STRING_LIST'
		-- for initializing tuple field
		do
			create Result.make_empty
			Result.append_converters (<<
				["x_mozilla_draft_info", agent new_draft_info],
				["content_type", agent new_content_type]
			>>)
		end

feature {NONE} -- Constants

	Date_representation: EL_DATE_TIME_REPRESENTATION
		once
			create Result.make ("Ddd, dd Mmm yyyy [0]hh:[0]mi:[0]ss tzd")
		end

	Kebab_case_title: EL_NAME_TRANSLATER
		once
			Result := kebab_case_translater (Case.Proper)
		end

	Mime_version_type: EL_VERSION_ARRAY
		-- store 2 x 2 version. Eg. 1.2
		once
			create Result.make (2, 2, 0)
		end

	Mozilla_key_set: EL_HASH_SET [STRING]
		once
			create Result.make_equal_array (<< space * 80 >>)
		end

	Transfer_encodings: EL_HASH_SET [STRING]
		once
			create Result.make_equal_array (<< "7bit", "8bit" >>)
		end

	Subject_decoder: TB_SUBJECT_LINE_DECODER
		once
			create Result.make
		end
end