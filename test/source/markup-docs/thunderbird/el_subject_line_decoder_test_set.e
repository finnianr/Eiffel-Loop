note
	description: "Subject line decoder test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-18 14:11:12 GMT (Tuesday 18th February 2020)"
	revision: "7"

class
	EL_SUBJECT_LINE_DECODER_TEST_SET

inherit
	EL_EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Initialization

	on_prepare
		do
			create subject.make
		end

feature -- Basic operations

	do_all (eval: EL_EQA_TEST_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("iso",		agent test_iso)
			eval.call ("utf_8",	agent test_utf_8)
		end

feature -- Tests

	test_iso
		do
			subject.set_line ("=?ISO-8859-15?Q?=DCber_My_Ching?=")
			assert ("same string", subject.decoded_line.to_latin_1 ~ "Über My Ching")
		end

	test_utf_8
		do
			subject.set_line ("=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=")
			assert ("same string", subject.decoded_line.same_string ({STRING_32} "Über€ My Ching"))

			subject.set_line ("=?UTF-8?Q?Journaleintr=c3=a4ge_bearbeiten?=")
			assert ("same string", subject.decoded_line.same_string ("Journaleinträge bearbeiten"))
		end

feature {NONE} -- Internal attributes

	subject: EL_SUBJECT_LINE_DECODER
end
