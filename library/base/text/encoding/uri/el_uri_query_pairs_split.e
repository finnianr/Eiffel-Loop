note
	description: "Splits query part of URI string on `&' character to get decoded name value pairs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-08 8:05:03 GMT (Thursday 8th June 2023)"
	revision: "2"

class
	EL_URI_QUERY_PAIRS_SPLIT

inherit
	EL_SPLIT_ON_CHARACTER_8 [STRING]
		rename
			make as make_split
		end

	EL_MODULE_TUPLE

create
	make

feature {NONE} -- Initialization

	make (query: STRING; is_url: BOOLEAN)
		local
			factory: EL_URI_ROUTINES
		do
			make_split (query, '&')
			name_string := factory.new_uri_string (is_url)
			value_string := factory.new_uri_string (is_url)
		end

feature -- Basic operations

	append_as_unencoded (query: STRING_GENERAL)
		-- append to `query' as unencoded characters except for ampersand
		do
			do_with_pairs (agent append_pair_to_unencoded (query, ?, ?))
		end

	do_with_pairs (set_name_value: PROCEDURE [EL_URI_QUERY_STRING_8, EL_URI_QUERY_STRING_8])
		local
			name_value_pair: STRING; name, value: EL_URI_QUERY_STRING_8
			pos_equals: INTEGER
		do
			name := name_string; value := value_string
			across Current as list loop
				name_value_pair := list.item
				pos_equals := name_value_pair.index_of ('=', 1)
				if pos_equals > 1 then
					name.set_encoded (name_value_pair, 1, pos_equals - 1)
					value.set_encoded (name_value_pair, pos_equals + 1, name_value_pair.count)
					set_name_value (name, value)
				end
			end
		end

feature {NONE} -- Implementation

	append_pair_to_unencoded (query: STRING_GENERAL; name, value: EL_URI_QUERY_STRING_8)
		-- append to `query' as unencoded characters except for ampersand
		do
			if not query.is_empty then
				query.append_code ({EL_ASCII}.Ampersand)
			end
			append_unencoded (query, name.decoded_32 (False))

			query.append_code ({EL_ASCII}.Equals_sign)
			if attached value.decoded_32 (False) as decoded then
				across Reserved_table as table loop
					if decoded.has (table.key [1]) then
						decoded.replace_substring_all (table.key, table.item)
					end
				end
				append_unencoded (query, decoded)
			end
		end

	append_unencoded (query: STRING_GENERAL; decoded: STRING_32)
		do
			if attached {STRING_8} query as str_8 then
				if decoded.is_valid_as_string_8 then
					str_8.append_string_general (decoded)
				end
			else
				query.append (decoded)
			end
		end

feature {NONE} -- Internal attributes

	name_string: EL_URI_QUERY_STRING_8

	value_string: EL_URI_QUERY_STRING_8

feature {NONE} -- Constants

	Reserved_table: HASH_TABLE [STRING_32, STRING_32]
		once
			create Result.make (2)
			Result ["&"] := "%%26"
			Result ["="] := "%%3D"
		end
end