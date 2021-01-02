note
	description: "Eiffel keywords"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 17:38:11 GMT (Saturday 2nd January 2021)"
	revision: "1"

class
	EL_EIFFEL_CONSTANTS

feature {NONE} -- Constants

	Reserved_word_list: LIST [ZSTRING]
			--
		local
			words, l_word: ZSTRING; case_variations: ARRAYED_LIST [ZSTRING]
		once
			words := Reserved_words
			words.replace_character ('%N', ' ')
			create case_variations.make (20)
			Result := words.split (' ')
			across Result as word loop
				l_word := Result.item
				if l_word.item (1).is_upper then
					case_variations.extend (l_word.as_lower)
				end
			end
			Result.append (case_variations)
		end

	Reserved_words: STRING =
		-- Eiffel reserved words
	"[
		across agent alias all and as assign attached attribute
		check class convert create Current
		debug deferred do
		else elseif end ensure expanded export external
		False feature from frozen
		if implies indexing inherit inspect invariant is
		like local loop
		not note
		obsolete old once only or
		Precursor
		redefine rename require rescue Result retry
		select separate some
		then True TUPLE
		undefine until
		variant Void
		when
		xor
	]"

end