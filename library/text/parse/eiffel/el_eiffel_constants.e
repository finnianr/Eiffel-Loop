note
	description: "Eiffel keywords"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-04 9:30:21 GMT (Thursday 4th April 2024)"
	revision: "11"

deferred class
	EL_EIFFEL_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Constraint_symbol: ZSTRING
		-- symbol used to constrain generic parameter
		once
			Result := "->"
		end

	E_extension: ZSTRING
		once
			Result := "e"
		end

	Dollor_left_brace: ZSTRING
		-- Used to indicate hyperlink substitution of class name in notes
		-- Eg. ${ZSTRING]
		once
			Result := "${"
		end

	Reserved_word_list: EL_ZSTRING_LIST
			--
		local
			manifest_text, word: ZSTRING
		once
			manifest_text := Reserved_words
			create Result.make (Reserved_words.occurrences (' ') + Reserved_words.occurrences ('%N') + 10)
			across manifest_text.split ('%N') as line loop
				across line.item.split (' ') as split loop
					word := split.item
					Result.extend (word)
					if word.item (1).is_upper then
						Result.extend (word.as_lower)
					end
				end
			end
		end

	Reserved_word_set: EL_HASH_SET [ZSTRING]
			--
		once
			create Result.make (Reserved_word_list.count)
			Reserved_word_list.do_all (agent Result.put)
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

feature {NONE} -- Character sets

	Class_name_character_set: EL_EIFFEL_CLASS_NAME_CHARACTER_SET
		-- Set of characters permissible in class name
		once
			create Result
		end

	First_letter_character_set: EL_EIFFEL_FIRST_LETTER_CHARACTER_SET
		-- Set of characters permissible in first letter of identifier
		once
			create Result
		end

	Identifier_character_set: EL_EIFFEL_IDENTIFIER_CHARACTER_SET
		-- Set of characters permissible in an Eiffel identifier
		once
			create Result
		end

	Type_name_character_set: EL_EIFFEL_TYPE_NAME_CHARACTER_SET
		-- Set of characters permissible in type name (which may have generic parameters)
		once
			create Result
		end

	Type_definition_character_set: EL_EIFFEL_TYPE_DEFINITION_CHARACTER_SET
		-- Set of characters permissible in type name (which may have generic parameters)
		once
			create Result
		end

end