note
	description: "Summary description for {SUBJECT_LINE_DECODER_TEST_SET}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUBJECT_LINE_DECODER_TEST_SET

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
			assert ("same string", subject.decoded.to_latin_1 ~ "Über My Ching")
		end

	test_utf_8
		do
			subject.set_line ("=?UTF-8?B?w5xiZXLigqwgTXkgQ2hpbmc=?=")
			assert ("same string", subject.decoded.to_unicode ~ {STRING_32} "Über€ My Ching")

			subject.set_line ("=?UTF-8?Q?Journaleintr=c3=a4ge_bearbeiten?=")
			assert ("same string", subject.decoded.to_unicode ~ "Journaleinträge bearbeiten")

		end

feature {NONE} -- Internal attributes

	subject: SUBJECT_LINE_DECODER
end
