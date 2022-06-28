note
	description: "Name translater table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-26 9:27:26 GMT (Sunday 26th June 2022)"
	revision: "1"

class
	EL_NAME_TRANSLATER_TABLE

inherit
	EL_CACHE_TABLE [EL_NAME_TRANSLATER, NATURAL]
		rename
			make as make_cache, item as translater_item
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
		do
			make_cache (5, agent new_translator)
		end

feature -- Access

	item (separater: CHARACTER; case: NATURAL): EL_NAME_TRANSLATER
		require
			valid_separater: ("_- %U").has (separater)
		do
			Result := translater_item (separater.natural_32_code |<< 8 | case)
		end

feature {NONE} -- Implementation

	new_translator (combined_key: NATURAL): EL_NAME_TRANSLATER
		local
			separater: CHARACTER; case: NATURAL
		do
			separater := (combined_key |>> 8).to_character_8; case := combined_key & Case_mask
			inspect separater
				when '-' then
					create {EL_KEBAB_CASE_TRANSLATER} Result.make_case (case)
				when '%U' then
					create {EL_CAMEL_CASE_TRANSLATER} Result.make_case (case)
				when ' ' then
					create {EL_ENGLISH_NAME_TRANSLATER} Result.make_case (case)
			else
				create {EL_SNAKE_CASE_TRANSLATER} Result.make_case (case)
			end
		end

feature {NONE} -- Constants

	Case_mask: NATURAL = 0xFF

end