note
	description: "Translation table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-08 18:25:18 GMT (Tuesday 8th April 2025)"
	revision: "38"

class
	EL_TRANSLATION_TABLE

inherit
	EL_ZSTRING_HASH_TABLE [ZSTRING]
		rename
			make as make_sized,
			merge as merge_other,
			put as put_table
		end

	EL_MODULE_LIO

	EL_LOCALE_CONSTANTS; EL_STRING_8_CONSTANTS

	EL_SHARED_KEY_LANGUAGE

create
	make, make_from_list, make_from_table

feature {NONE} -- Initialization

	make (a_language: STRING)
		do
			language := a_language
			make_default
		end

	make_default
		do
			create duplicate_list.make_empty
			make_equal (60)
		end

	make_from_list (a_language: STRING; items_list: LIST [EL_TRANSLATION_ITEM])
		do
			make (a_language)
			from items_list.start until items_list.after loop
				put (items_list.item.text, items_list.item.key)
				items_list.forth
			end
		end

	make_from_table (a_language: STRING; table: EL_MULTI_LANGUAGE_TRANSLATION_TABLE)
		require
			has_translation: table.language_set.has (a_language)
		do
			make (a_language); merge (table)
		end

feature -- Access

	language: STRING

feature -- Measurement

	duplicate_count: INTEGER
		do
			Result := duplicate_list.count
		end

	word_count: INTEGER
		-- count of all translation words except for variable references
		do
			from start until after loop
				Result := Result + super_readable (item_for_iteration).word_count (True)
				forth
			end
		end

feature -- Basic operations

	print_duplicates
		do
			across duplicate_list as id loop
				lio.put_string_field ("id", id.item)
				lio.put_string (" DUPLICATE")
				lio.put_new_line
			end
			lio.put_new_line
		end

feature -- Status query

	has_duplicates: BOOLEAN
		do
			Result := duplicate_list.count > 0
		end

feature -- Element change

	merge (table: EL_MULTI_LANGUAGE_TRANSLATION_TABLE)
		do
			if attached table.key_list_for (language) as language_key_list then
				accommodate (language_key_list.count)
				across language_key_list as list loop
					if attached list.item as key and then key.count > 3 then
						put (table [key], key.substring (4, key.count))
					end
				end
			end
		end

feature {NONE} -- Implementation

	put (a_translation, translation_id: ZSTRING)
		local
			translation: ZSTRING; z: EL_ZSTRING_ROUTINES
		do
			if a_translation ~ id_variable then
				translation := translation_id
			else
				translation := a_translation
				translation.prune_all_leading ('%N')
				translation.right_adjust
				z.unescape_substitution_marks (translation)
			end
			put_table (translation, translation_id)
			if conflict then
				duplicate_list.extend (translation_id)
			end
		end

feature {NONE} -- Internal attributes

	duplicate_list: EL_ZSTRING_LIST

feature {NONE} -- Constants

	ID_variable: ZSTRING
		once
			Result := "$id"
		end

end