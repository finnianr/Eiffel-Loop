note
	description: "Summary description for {VCF_CONTACT_SPLITTER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-15 11:46:04 GMT (Sunday 15th October 2017)"
	revision: "7"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_SPLITTER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_test ("contacts.vcf", agent test_split, 4176544362)
		end

	test_split (vcf_path: EL_FILE_PATH)
			--
		local
		do
			create command.make (vcf_path)
			normal_run
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				valid_required_argument ("in", "Path to vcf contacts file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "split_vcf"

	Description: STRING = "Split vcf contacts file into separate files"

	Log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{VCF_CONTACT_SPLITTER_APP}, All_routines],
				[{VCF_CONTACT_SPLITTER}, All_routines]
			>>
		end

end
