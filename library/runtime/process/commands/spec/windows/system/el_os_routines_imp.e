note
	description: "Windows implementation of `EL_OS_ROUTINES_I' interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-01 9:18:16 GMT (Friday 1st July 2016)"
	revision: "5"

class
	EL_OS_ROUTINES_IMP

inherit
	EL_OS_ROUTINES_I
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
				Result.append (cpu_info (Extended_function_CPUID_Information + i).string)
				i := i + 1
			end
			Result.left_adjust
		end

feature {NONE} -- Implementation

	cpu_info (info_type: INTEGER): C_STRING
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