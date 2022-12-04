note
	description: "Pattern split string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 18:58:27 GMT (Saturday 3rd December 2022)"
	revision: "14"

class
	EL_PATTERN_SPLIT_STRING_LIST

inherit
	EL_SOURCE_TEXT_PROCESSOR
		undefine
			is_equal, copy
		redefine
			make_default
		end

	LINKED_LIST [ZSTRING]
		rename
			make as make_default,
			do_all as do_with_strings
		redefine
			make_default
		end

	TP_FACTORY
		undefine
			is_equal, copy
		end

	EL_ZSTRING_CONSTANTS

create
	make, make_with_delimiter

feature {NONE} -- Initialization

	make (character_set: READABLE_STRING_GENERAL)
			--
		require
			at_least_one_delimiter: character_set.count >= 1
		do
			make_with_delimiter (agent one_character_from (character_set))
		end

	make_default

		do
			Precursor {EL_SOURCE_TEXT_PROCESSOR}
			Precursor {LINKED_LIST}
		end

feature -- Element change

	extend_from_string (target: ZSTRING)
			--
		require
			target_not_void: target /= Void
		do
--			log.enter_with_args ("extend_from_string", <<target>>)
			set_source_text (target)
			find_all (agent on_unmatched_text)
			set_source_text (Empty_string)
--			log.exit
		end

	keep_delimiters
			--
		require
			valid_delimiting_pattern: delimiting_pattern /= Void
		do
			delimiting_pattern.set_action (agent on_unmatched_text)
		end

	set_from_string (target: ZSTRING)
			--
		do
			wipe_out
			extend_from_string (target)
		end

feature {NONE} -- Parsing actions

	on_unmatched_text (start_index, end_index: INTEGER)
			--
		do
--			log.enter_with_args ("on_unmatched_text", <<text>>)
			if end_index >= start_index then
				extend (source_substring (start_index, end_index, True))
			end
--			log.exit
		end

end