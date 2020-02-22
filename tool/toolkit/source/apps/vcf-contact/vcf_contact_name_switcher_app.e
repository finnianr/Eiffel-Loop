note
	description: "Vcf contact name switcher app"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-20 17:38:41 GMT (Thursday 20th February 2020)"
	revision: "11"

class
	VCF_CONTACT_NAME_SWITCHER_APP

inherit
	EL_REGRESSION_TESTABLE_COMMAND_LINE_SUB_APPLICATION [VCF_CONTACT_NAME_SWITCHER]
		rename
			extra_log_filter as no_log_filter
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

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("in", "Path to vcf contacts file", << file_must_exist >>)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make ("")
		end

feature {NONE} -- Constants

	Option_name: STRING = "vcf_switch"

	Description: STRING = "Switch first and second names in vCard contacts file"

end
