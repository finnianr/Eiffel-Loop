note
	description: "Test set for [$source LIMITED_FOLD_ARRAY]"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:47:36 GMT (Tuesday 8th February 2022)"
	revision: "2"

class
	LIMITED_ARRAY_TEST_SET

inherit
	EQA_TEST_SET

	EL_MODULE_LOG

feature -- Tests

	test_fold_permutations
		local
			one_core_checksum, multi_core_checksum: NATURAL
		do
			log.enter ("test_fold_permutations")
			across << "0010010010010", "01001001001" >> as seq loop
				log.put_labeled_string ("sequence", seq.item)
				log.put_new_line
				one_core_checksum := one_core_fold_checksum (seq.item)
				multi_core_checksum := multi_core_fold_checksum (seq.item)
				assert ("one_core_checksum = multi_core_checksum",  one_core_checksum = multi_core_checksum)
			end
			log.exit
		end

feature {NONE} -- Implementation

	multi_core_fold_checksum (sequence: STRING): NATURAL
		local
			fold: LIMITED_FOLD_ARRAY; testable_fold: TESTABLE_LIMITED_FOLD_ARRAY
			pf: like new_pf_hp
		do
			log.enter ("multi_core_fold_checksum")
			create fold.make (sequence)
			create testable_fold.make (sequence)
			pf := new_pf_hp (sequence)

			-- Equivalent to loop in `{MULTI_CORE_PF_COMMAND_2_1}.gen_folds'
			from until fold.is_last_north loop
				testable_fold.set_data (fold)
				testable_fold.permute (pf)
				fold.partial_permute
			end
			Result := testable_fold.checksum
			log.put_labeled_string ("Result", Result.out)
			log.exit
		end

	one_core_fold_checksum (sequence: STRING): NATURAL
		local
			fold: TESTABLE_FOLD_ARRAY
		do
			log.enter ("one_core_fold_checksum")
			create fold.make (sequence)
			fold.permute (new_pf_hp (sequence))
			Result := fold.checksum
			log.put_labeled_string ("Result", Result.out)
			log.exit
		end

	new_pf_hp (sequence: STRING): PF_COMMAND_2_0 [GRID_2_5]
		do
			create Result.make (sequence, "workarea/autotest")
		end

feature {NONE} -- Constants


end
