note
	description: "[
		Deferred i18n of common words accessible via [$source EL_SHARED_WORD] as `Word'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-19 13:05:20 GMT (Saturday 19th February 2022)"
	revision: "6"

class
	EL_WORD_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		rename
			english_table as Empty_table,
			print as io_print
		redefine
			upper_case_texts
		end

create
	make

feature -- Access

	first_letter_yes: CHARACTER_32
		-- first letter of yes as lower case
		do
			if yes.count > 0 then
				Result := yes [1].as_lower
			end
		end

feature -- Button Texts

	abort: ZSTRING

	add: ZSTRING

	apply: ZSTRING

	cancel: ZSTRING

	close: ZSTRING

	complete: ZSTRING

	confirmation: ZSTRING

	continue: ZSTRING

	discard: ZSTRING

	directory: ZSTRING

	error: ZSTRING

	file: ZSTRING

	ignore: ZSTRING

	information: ZSTRING

	next: ZSTRING

	no: ZSTRING

	ok: ZSTRING

	open: ZSTRING

	previous: ZSTRING

	print: ZSTRING

	progress: ZSTRING

	question: ZSTRING

	rename_: ZSTRING

	retry_: ZSTRING

	save: ZSTRING

	select_: ZSTRING

	warning: ZSTRING

	yes: ZSTRING

feature {NONE} -- Implementation

	upper_case_texts: like None
		do
			Result := << ok >>
		end

end