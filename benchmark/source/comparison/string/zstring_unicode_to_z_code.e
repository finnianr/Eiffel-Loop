note
	description: "Once off comparisons for developer testing"
	notes: "[
		Passes over 2000 millisecs (in descending order)

			if unicode <= 0xFF then                    : 16010.0 times (100%)
			inspect unicode |>> 8                      : 15921.0 times (-0.6%)
			if unicode < 0x100 then                    : 15879.0 times (-0.8%)
			inspect b.leading_zeros_count_32 (unicode) : 15645.0 times (-2.3%)
			Pure bit arithmetic, no branching          : 15567.0 times (-2.8%)
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-04 10:17:35 GMT (Monday 4th December 2023)"
	revision: "19"

class
	ZSTRING_UNICODE_TO_Z_CODE

inherit
	STRING_BENCHMARK_COMPARISON

	HEXAGRAM_NAMES
		export
			{NONE} all
		end

create
	make

feature -- Access

	Description: STRING = "{ZSTRING}.unicode_to_z_code variations"

feature -- Basic operations

	execute
		local
			str: ZSTRING
		do
			str := Name_manifest

			compare ("Iterate ZSTRING areas", <<
				["if unicode < 0x100 then",						  agent do_method (str.area, str.unencoded_area, 1, str.count)],
				["if unicode <= 0xFF then",						  agent do_method (str.area, str.unencoded_area, 2, str.count)],
				["inspect b.leading_zeros_count_32 (unicode)", agent do_method (str.area, str.unencoded_area, 3, str.count)],
				["inspect unicode |>> 8",							  agent do_method (str.area, str.unencoded_area, 4, str.count)],
				["Pure bit arithmetic, no branching",			  agent do_method (str.area, str.unencoded_area, 5, str.count)]
			>>)
		end

feature {NONE} -- Operations

	do_method (area: SPECIAL [CHARACTER]; area_32: SPECIAL [CHARACTER_32]; id, count: INTEGER)
		local
			iter: EL_COMPACT_SUBSTRINGS_32_ITERATION; block_index, i: INTEGER
			uc: CHARACTER_32; c_i: CHARACTER; z_code: NATURAL
		do
			across 1 |..| 1000 as n loop
				block_index := 0
				from until i = count loop
					inspect area [i]
						when Substitute then
							uc := iter.item ($block_index, area_32, i + 1)
							inspect id
								when 1 then
									z_code := unicode_to_z_code (uc.natural_32_code)
								when 2 then
									z_code := unicode_to_z_code_lt_eq_0xFF (uc.natural_32_code)
								when 3 then
									z_code := unicode_to_z_code_inspect_leading_zero_count (uc.natural_32_code)
								when 4 then
									z_code := unicode_to_z_code_when_0 (uc.natural_32_code)
								when 5 then
									z_code := unicode_to_z_code_bitshift_only (uc.natural_32_code)
							end
					else
					end
					i := i + 1
				end
			end
		end

	frozen unicode_to_z_code_bitshift_only (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		local
			b: EL_BIT_ROUTINES
		do
			Result := (Sign_bit & (b.zero_or_one (unicode |>> 8) |<< 31)) | unicode
		ensure
			reversbile: z_code_to_unicode (Result) = unicode
		end

	frozen unicode_to_z_code_inspect_leading_zero_count (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		local
			b: EL_BIT_ROUTINES
		do
			inspect b.leading_zeros_count_32 (unicode)
				when 0 .. 23 then
					Result := unicode
			else
				Result := Sign_bit | unicode
			end
		ensure
			same_as_simple: Result = unicode_to_z_code (unicode)
		end

	frozen unicode_to_z_code_leading_zeros_1_to_15 (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		local
			b: EL_BIT_ROUTINES
		do
			inspect b.leading_zeros_count_32 (unicode |>> 8)
				when 31 then
					Result := Sign_bit | unicode
			else
				Result := unicode
			end
		ensure
			same_as_simple: Result = unicode_to_z_code (unicode)
		end

	frozen unicode_to_z_code_lt_eq_0xFF (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		do
			if unicode <= 0xFF then
				Result := Sign_bit | unicode
			else
				Result := unicode
			end
		ensure
			reversbile: z_code_to_unicode (Result) = unicode
		end

	frozen unicode_to_z_code_when_0 (unicode: NATURAL): NATURAL
		-- distinguish UCS4 characters below 0xFF from latin encoding by turning on the sign bit.
		do
			inspect unicode |>> 8
				when 0 then
					Result := Sign_bit | unicode
			else
				Result := unicode
			end
		ensure
			same_as_simple: Result = unicode_to_z_code (unicode)
		end

note
	notes: "[
		**24 Nov 2023**
		
		**to_string_32_v2** uses technique:

			when Substitute then
				interval_count := unencoded_interval_count (area_32, j_lower)
				area_out.copy_data (area_32, j_lower, old_count + i, interval_count)
				j_lower := j_lower + interval_count + 2
				i := i + interval_count

		Passes over 500 millisecs (in descending order)

			to_string_32  : 164.0 times (100%)
			to_string_32_v2 :  95.0 times (-42.1%)
			
		**prune_all_v2** use technique:

			when Substitute then
				interval_count := unencoded_interval_count (uc_area, k_lower)
				k_upper := k_lower + interval_count - 1
			
		Passes over 500 millisecs (in descending order)

			prune_all    :  38.0 times (100%)
			prune_all_v2 :  38.0 times (-0.0%)
			
		**when 0 .. C then VS if x <= C then**

		Passes over 1000 millisecs (in descending order)

			when 0 .. 0x7F then  : 16645498.0 times (100%)
			when 0 .. 0xFF then  : 16610377.0 times (-0.2%)
			if code <= 0x7F then : 16558972.0 times (-0.5%)
			if code <= 0xFF then : 13450191.0 times (-19.2%)

	]"

end