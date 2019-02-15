note
	description: "Comma separated words list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-15 12:12:48 GMT (Friday 15th February 2019)"
	revision: "2"

class
	EL_COMMA_SEPARATED_WORDS_LIST

inherit
	ECD_RECOVERABLE_CHAIN [EL_COMMA_SEPARATED_WORDS]
		rename
			make_chain_implementation as make_list
		undefine
			valid_index, is_inserted, is_equal,
			first, last,
			do_all, do_if, there_exists, has, for_all,
			start, search, finish,
			append_sequence, swap, force, copy, prune_all, prune, move, new_cursor,
			at, put_i_th, i_th, go_i_th
		redefine
			apply_editions
		select
			remove, extend, replace
		end

	EL_ARRAYED_LIST [EL_COMMA_SEPARATED_WORDS]
		rename
			make as make_list,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		export
			{NONE} chain_remove, chain_replace
		end

	EL_MODULE_BUILD_INFO
		undefine
			copy, is_equal
		end

	STRING_HANDLER
		undefine
			copy, is_equal
		end

create
	make_from_file, make_from_file_and_encrypter

feature -- Basic operations

	update_words (table: EL_WORD_TOKEN_TABLE)
		local
			new_words: EL_ZSTRING_LIST
			delta_count: INTEGER
		do
			if table.count > word_count then
				delta_count := table.count - word_count
				word_count := table.count
				new_words := table.word_list.sub_list (word_count - delta_count + 1, word_count)
				extend (new_words)
			end
		end

feature -- Basic operations

	fill_table (table: EL_WORD_TOKEN_TABLE)
		do
			from start until after loop
				item.word_list.do_all (agent table.put)
				forth
			end
		end

feature -- Status query

	is_restored: BOOLEAN

feature {NONE} -- Implementation

	actual_word_count: INTEGER
		do
			from start until after loop
				Result := Result + item.words.occurrences (',') + 1
				forth
			end
		end

	apply_editions
		do
			Precursor
			word_count := actual_word_count
			if editions.read_count > 0 and not editions.has_checksum_mismatch then
				is_restored := True
			end
		end

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end

feature {NONE} -- Event handler

	on_delete
		do
		end

feature {NONE} -- Internal attributes

	word_count: INTEGER
end
