note
	description: "Command to iterate lines in VCF contact file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-21 10:06:54 GMT (Monday 21st April 2025)"
	revision: "5"

deferred class
	VCF_CONTACT_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_STRING_STATE_MACHINE [STRING_8, CHARACTER_8]
		rename
			make as make_machine
		end

	EL_MODULE_FILE_SYSTEM

	EL_MODULE_TUPLE

feature {EL_APPLICATION} -- Initialization

	make (a_vcf_path: FILE_PATH)
		do
			make_machine
			vcf_path := a_vcf_path
			create pair.make_empty
		end

feature {NONE} -- Internal attributes

	pair: EL_NAME_VALUE_PAIR [STRING]

	vcf_path: FILE_PATH

feature {NONE} -- Constants

	Field: TUPLE [begin, end_, full_name, name, x_irmc_luid: STRING]
		once
			create Result
			Tuple.fill (Result, "BEGIN, END, FN, N, X-IRMC-LUID")
		end

end