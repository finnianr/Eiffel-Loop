note
	description: "Summary description for {VCF_CONTACT_SPLITTER_APP}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VCF_CONTACT_SPLITTER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATTION [VCF_CONTACT_SPLITTER]
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

	make_action: PROCEDURE [like command, like default_operands]
		do
			Result := agent command.make
		end

	default_operands: TUPLE [vcf_path: EL_FILE_PATH]
		do
			create Result
			Result.vcf_path := ""
		end

	argument_specs: ARRAY [like Type_argument_specification]
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
				[{VCF_CONTACT_SPLITTER_APP}, "*"],
				[{EL_TEST_ROUTINES}, "*"],
				[{VCF_CONTACT_SPLITTER}, "*"]
			>>
		end

end
