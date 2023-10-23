note
	description: "Windows implementation of [$source EL_SYSTEM_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-27 8:57:18 GMT (Wednesday 27th September 2023)"
	revision: "7"

class
	EL_SYSTEM_ROUTINES_IMP

inherit
	EL_SYSTEM_ROUTINES_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

feature {NONE} -- Factory

	new_CPU_model_name: STRING
		--
		local
			i: INTEGER; info_string: EL_C_STRING_8
		do
			create info_string.make (Info_block_width * Model_part_count)
		-- Eg. Intel Core(TM)| i7-3615QM| CPU @ 2.30GHz
			from i := 0 until i = Model_part_count loop
				cwin_cpu_id (info_string.base_address + i * Info_block_width, Extended_function_CPUID_Information + i)
				i := i + 1
			end
			create Result.make_from_c (info_string.base_address)
			Result.left_adjust
		end

feature {NONE} -- Constants

	Info_block_width: INTEGER = 16

	Model_part_count: INTEGER = 3

	Extended_function_CPUID_Information: INTEGER = 0x80000002

feature {NONE} -- C Externals

	cwin_cpu_id (info_array: POINTER; info_type: INTEGER)
		-- void __cpuid(int CPUInfo[4], int InfoType);
	external
		"C [macro <intrin.h>] (int*, int)"
	alias
		"__cpuid"
	end

end