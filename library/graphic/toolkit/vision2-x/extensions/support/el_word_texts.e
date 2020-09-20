note
	description: "Common button and title words accessible via [$source EL_SHARED_WORD] as `Word'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-19 9:50:23 GMT (Saturday 19th September 2020)"
	revision: "1"

class
	EL_WORD_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		rename
			print as io_print
		end

create
	make

feature -- Button Texts

	add: ZSTRING

	abort: ZSTRING

	apply: ZSTRING

	cancel: ZSTRING

	close: ZSTRING

	complete: ZSTRING

	continue: ZSTRING

	discard: ZSTRING

	ignore: ZSTRING

	no: ZSTRING

	ok: ZSTRING

	open: ZSTRING

	print: ZSTRING

	rename_: ZSTRING

	retry_: ZSTRING

	save: ZSTRING

	select_: ZSTRING

	yes: ZSTRING

feature -- Labels

	progress: ZSTRING

feature -- Titles

	title_confirmation: ZSTRING

	title_error: ZSTRING

	title_information: ZSTRING

	title_question: ZSTRING

	title_warning: ZSTRING

feature {NONE} -- Constants

	English_table: STRING = "[
		ok:
			OK
	]"
end