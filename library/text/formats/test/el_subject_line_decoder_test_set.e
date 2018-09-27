note
	description: "Subject line decoder test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-27 13:30:41 GMT (Thursday 27th September 2018)"
	revision: "3"

class
	EL_SUBJECT_LINE_DECODER_TEST_SET

inherit
	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Events

	on_prepare
		do
			create subject.make
		end

feature -- Access

	test_iso
		do
			subject.set_line ("=?ISO-8859-15?Q?=DCber_My_Ching?=")
			assert ("same string", subject.decoded_line.to_latin_1 ~ "Über My Ching")
		end

	test_utf_8
		do
			subject.set_line ("=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=")
			assert ("same string", subject.decoded_line.to_unicode ~ {STRING_32} "Über€ My Ching")

			subject.set_line ("=?UTF-8?Q?Journaleintr=c3=a4ge_bearbeiten?=")
			assert ("same string", subject.decoded_line.to_unicode ~ "Journaleinträge bearbeiten")

		end

feature {NONE} -- Internal attributes

	subject: EL_SUBJECT_LINE_DECODER
end
