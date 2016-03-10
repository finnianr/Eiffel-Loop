note
	description: "[
		Isolate anything at end of title that looks like a year in brackets (and possibley preceded by a hyphen)
		Trim unwanted ".mp3" suffix
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	ID3_LATIN1_FIELD_EDITOR

inherit
	EL_STRING_EDITOR

	EL_MODULE_STRING

create
	make

feature {NONE} -- Implementation

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := one_of (<<
				all_of (<< start_of_line, default_word >>)		|to| agent on_default_word (?, True),
				default_word												|to| agent on_default_word (?, False)
			>>)
		end

	default_word: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of (<<
				latin1_alpha_numeric,
				zero_or_more (
					one_of (<< latin1_alpha_numeric, one_character_from ("'`") >>)
				)
			>>)
		end

feature {NONE} -- Match actions

	on_default_word (matched_text: EL_STRING_VIEW; first_word_in_line: BOOLEAN)
			--
		local
			normalized_word, upper_word: EL_ASTRING
		do
			log.enter_with_args ("on_default_word", << matched_text >>)
			normalized_word := matched_text; normalized_word.to_lower
			upper_word := matched_text; upper_word.to_upper
			inspect normalized_word.count
				when 1 then
					if not (<< 'y' >>).has (normalized_word @ 1) then
						normalized_word.put (upper_word [1], 1)

					end

				when 2 then
					if first_word_in_line then
						normalized_word.put (upper_word [1], 1)
					end
			else
				if normalized_word.item_code (2) = {ASCII}.Grave_accent then
					normalized_word.put_code ({ASCII}.singlequote.to_natural_32, 2)

				end
				normalized_word.put (upper_word [1], 1)
				if normalized_word.item_code (2) = {ASCII}.singlequote then
					normalized_word.put (upper_word [3], 3)
				end
			end
			put_string (normalized_word)
			log.exit
		end

end
