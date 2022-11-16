note
	description: "Windows implementation of [$source EL_SYSTEM_ROUTINES_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "6"

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
			i: INTEGER
		do
			create Result.make (50)
			from i := 2 until i > 4 loop
				Result.append (new_cpu_id_info (Extended_function_CPUID_Information + i).string)
				i := i + 1
			end
			Result.left_adjust
		end

feature {NONE} -- Implementation

	new_cpu_id_info (info_type: INTEGER): C_STRING
		local
			buffer: MANAGED_POINTER
		do
			create buffer.make (16)
			cwin_cpu_id (buffer.item, info_type)
			create Result.make_by_pointer_and_count (buffer.item, buffer.count)
		end

feature {NONE} -- Constants

	Extended_function_CPUID_Information: INTEGER = 0x80000000

feature {NONE} -- C Externals

	cwin_cpu_id (info_array: POINTER; info_type: INTEGER)
		-- void __cpuid(int CPUInfo[4], int InfoType);
	external
		"C [macro <intrin.h>] (int*, int)"
	alias
		"__cpuid"
	end

end