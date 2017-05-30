note
	description: "Summary description for {VCF_CONTACT_SPLITTER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-29 23:19:58 GMT (Monday 29th May 2017)"
	revision: "3"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_SPLITTER]
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

	make_action: PROCEDURE [like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [vcf_path: EL_FILE_PATH]
		do
			create Result
			Result.vcf_path := ""
		end

	argument_specs: ARRAY [like specs.item]
		do
			Result := <<
				required_existing_path_argument ("in", "Path to vcf contacts file")
			>>
		end

feature {NONE} -- Constants

	Option_name: STRING = "split_vcf"

	Description: STRING = "Split vcf contacts file into separate files"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{VCF_CONTACT_SPLITTER_APP}, All_routines],
				[{VCF_CONTACT_SPLITTER}, All_routines]
			>>
		end

end
