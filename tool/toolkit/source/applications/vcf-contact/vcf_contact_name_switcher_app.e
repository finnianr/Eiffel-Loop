note
	description: "Summary description for {VCF_CONTACT_NAME_SWITCHER_APP}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-19 6:35:19 GMT (Tuesday 19th July 2016)"
	revision: "1"

class
	VCF_CONTACT_NAME_SWITCHER_APP

inherit
	EL_TESTABLE_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_NAME_SWITCHER]
		redefine
			Option_name
		end

create
	make

feature -- Test

	test_run
			--
		do
			Test.do_file_test ("contacts.vcf", agent test_split, 3075036997)
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

	Option_name: STRING = "vcf_switch"

	Description: STRING = "Switch first and second names in vCard contacts file"

	Log_filter: ARRAY [like Type_logging_filter]
			--
		do
			Result := <<
				[{VCF_CONTACT_NAME_SWITCHER_APP}, All_routines],
				[{VCF_CONTACT_NAME_SWITCHER}, All_routines]
			>>
		end

end