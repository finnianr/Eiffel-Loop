note
	description: "General test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-12 9:49:37 GMT (Monday 12th December 2022)"
	revision: "28"

class
	GENERAL_TEST_SET

inherit
	EL_EQA_TEST_SET

	EL_MODULE_BASE_64; EL_MODULE_EXECUTION_ENVIRONMENT; EL_MODULE_LIO; EL_MODULE_NAMING

	EL_MODULE_REUSEABLE

	SHARED_HEXAGRAM_STRINGS

feature -- Basic operations

	do_all (eval: EL_TEST_SET_EVALUATOR)
		-- evaluate all tests
		do
			eval.call ("any_array_numeric_type_detection", agent test_any_array_numeric_type_detection)
			eval.call ("base_64_codec", agent test_base_64_codec)
			eval.call ("base_64_encode_decode", agent test_base_64_encode_decode)
			eval.call ("character_32_status_queries", agent test_character_32_status_queries)
			eval.call ("environment_put", agent test_environment_put)
			eval.call ("math_precision", agent test_math_precision)
			eval.call ("named_thread", agent test_named_thread)
			eval.call ("naming", agent test_naming)
			eval.call ("reusable_strings", agent test_reusable_strings)
			eval.call ("reverse_managed_pointer", agent test_reverse_managed_pointer)
		end

feature -- Tests

	test_any_array_numeric_type_detection
		local
			array: ARRAY [ANY]
		do
			array := << (1).to_reference, 1.0, (1).to_integer_64 >>
			assert ("same types", array.item (1).generating_type ~ {INTEGER_32_REF})
			assert ("same types", array.item (2).generating_type ~ {DOUBLE})
			assert ("same types", array.item (3).generating_type ~ {INTEGER_64})
		end

	test_base_64_codec
		note
			testing: "covers/{EL_BASE_64_CODEC}.joined, covers/{EL_BASE_64_CODEC}.decoded_special",
						"covers/{EL_BASE_64_CODEC}.encoded_special"
		local
			list: ARRAYED_LIST [NATURAL_8]; decoded, gobo_decoded: SPECIAL [NATURAL_8]
			encoded, gobo_encoded: STRING; r: RANDOM
		do
			gobo_decoded := Gobo_base_64.decoded_special (Base_64_data)
			decoded := Base_64.decoded_special (Base_64_data)
			assert ("same data", decoded ~ gobo_decoded)

			create r.make
			create list.make (100)
			from until list.full loop
				list.extend ((r.item \\ 100).to_natural_8)
				r.forth
				encoded := Base_64.encoded_special (list.area, False)
				gobo_encoded := Gobo_base_64.encoded_special (list.area)
				assert ("same encoding", encoded ~ gobo_encoded)
				assert ("same list", Base_64.decoded_special (encoded) ~ list.area)
			end
		end

	test_base_64_encode_decode
		-- GENERAL_TEST_SET.test_base_64_encode_decode
		note
			testing: "covers/{EL_BASE_64_CODEC}.decoded_special",
						"covers/{EL_BASE_64_CODEC}.encoded_special"
		local
			conv: EL_UTF_8_CONVERTER; text_utf_8, text_base_64, decoded: STRING
			i, l_count: INTEGER
		do
			text_utf_8 := conv.utf_32_string_to_string_8 (Hexagram.Chinese_text)
			text_base_64 := Base_64.encoded (text_utf_8, True)
			lio.put_string_field_to_max_length ("Base 64", text_base_64, 300)
			lio.put_new_line
			decoded := Base_64.decoded (text_base_64)
			assert ("decoded OK", decoded ~ text_utf_8)
		end

	test_character_32_status_queries
		do
--			Bug in finalized exe for compiler version 16.05
--			assert ("not is_space", not ({CHARACTER_32}'€').is_space)
--			assert ("not is_digit ", not ({CHARACTER_32}'€').is_digit)

			assert ("not is_alpha", not ({CHARACTER_32}'€').is_alpha)
			assert ("not is_punctuation", not ({CHARACTER_32}'€').is_punctuation)
			assert ("not is_control", not ({CHARACTER_32}'€').is_control)
		end

	test_environment_put
		local
			name: STRING
		do
			name := "EIFFEL_LOOP_DOC"
			Execution_environment.put ("eiffel-loop", name)
			Execution_environment.put ("", name)
			assert ("not attached", not attached Execution_environment.item (name))
		end

	test_math_precision
		local
			math: EL_DOUBLE_MATH_ROUTINES
		do
			assert ("equal within 1 percent", math.approximately_equal (169, 170, 0.01))
			assert ("not equal within 1 percent", not math.approximately_equal (168, 170, 0.01))
		end

	test_named_thread
		local
			t: EL_NAMED_THREAD
		do
			create t
			assert ("same string", t.name.same_string ("Named Thread"))
		end

	test_naming
		note
			testing: "covers/{EL_NAMING_ROUTINES}.to_title",
						"covers/{EL_NAMING_ROUTINES}.class_description"
		local
			eif_name, title, description: STRING
			excluded_words: EL_STRING_8_LIST
		do
			eif_name := "hex_11_software"
			create title.make (eif_name.count)
			Naming.to_title (eif_name, title, ' ', Naming.empty_word_set)
			assert ("is title", title ~ "Hex 11 Software")

			excluded_words := "EL"
			description := Naming.class_description_from ({EL_OCCURRENCE_INTERVALS [STRING]}, excluded_words)
			assert ("expected description", description ~ "Occurrence intervals for type STRING_8")

			description := Naming.class_description_from (Current, excluded_words)
			assert ("expected description", description ~ "General test SET")
		end

	test_reusable_strings
		local
			s1, s2, s3, s4: ZSTRING
		do
			across Reuseable.string as reuse loop
				s1 := reuse.item
				assert ("empty string", s1.is_empty)
				s1.append_string_general ("abc")
				across Reuseable.string as reuse2 loop
					s3 := reuse2.item
					assert ("s3 is new instance", s1 /= s3)
				end
			end
			across Reuseable.string as reuse loop
				s2 := reuse.item
				assert ("empty string", s2.is_empty)
				across Reuseable.string as reuse2 loop
					s4 := reuse2.item
				end
			end
			assert ("instance recycled", s1 = s2)
			assert ("nested instances recycled", s3 = s4)
		end

	test_reverse_managed_pointer
		local
			ptr: MANAGED_POINTER; reverse_ptr: EL_REVERSE_MANAGED_POINTER
			n_16: NATURAL_16; n_32: NATURAL_32; n_64: NATURAL_64
		do
			create ptr.make (8)
			create reverse_ptr.share_from_pointer (ptr.item, 8)

			ptr.put_natural_16 (0x11_22, 0)
			n_16 := reverse_ptr.read_natural_16 (0)
			assert ("reversed", n_16 = 0x22_11)

			ptr.put_natural_32 (0x11_22_33_44, 0)
			n_32 := reverse_ptr.read_natural_32 (0)
			assert ("reversed", n_32 = 0x44_33_22_11)

			ptr.put_natural_64 (0x11_22_33_44_55_66_77_88, 0)
			n_64 := reverse_ptr.read_natural_64 (0)
			assert ("reversed", n_64 = 0x88_77_66_55_44_33_22_11)
		end

feature {NONE} -- Constants

	Base_64_data: STRING
		once
			Result := "[
				SAFweR4G0xAxjN11FNtzojS0rrJitfeQh9KUa9kuuk1/6Wk7wDBmDpTXx3hZ4e48ovkIs50w3YSFSsH1EyseOe
				/OsvGW5ncCl3V08u0whToDEXDCQc3LAT4U6ULIYgw4+Kmx9Xoi9lINa4iS8ze/p2NPIvL61TDuYhocxX1ux7xu
				OGXlvDw4mNhnNWMqT1671/XW+I+WMMO5JyA0Sw20LWGGAPbKm/gZj+X5qAuLAQKz7hoUYX0SCep8mrKgprDbdd
				jxw4uSuCTvZtxyORmhrB4u6nwMPDx8Rq7ECzpMAGxsVFZh959BvwmtXhR7vs3tTYRZ7YBTwLopkCuhlGQXMQ==
			]"
		end

	Gobo_base_64: GOBO_BASE_64_ROUTINES
		once
			create Result
		end

end