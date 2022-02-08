note
	description: "Prediction of protein-folding in 2D HP model"

	author: "Finnian Reilly"
	copyright: "[
	Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly
	]"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:47:36 GMT (Tuesday 8th February 2022)"
	revision: "2"

deferred class
	PROTEIN_FOLDING_COMMAND

inherit
	EL_APPLICATION_COMMAND

	EL_MODULE_FILE_SYSTEM; EL_MODULE_LOG

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_strseq: like strseq; a_output_path: FILE_PATH)
		require
			valid_count: a_strseq.count >= 3
		do
			strseq := a_strseq
			strseq.compare_objects
			output_path := a_output_path.twin
			if not output_path.base.ends_with_general ("txt") then
				output_path.append_step ("folds-" + strseq + ".txt")
			end
			File_system.make_directory (output_path.parent)
			create output.make_with_name (output_path)
			create crc.make
		end

feature -- Access

	output_path: FILE_PATH

	strseq: STRING

feature -- Basic operations

	execute
		do
			log.enter ("execute")
			lio.put_labeled_string ("Calculating folds for HP sequence", seq.to_general)
			lio.put_new_line

			gen_folds

			if crc.checksum > 0 then
				log.put_labeled_string ("Calculation checksum", crc.checksum.out)
				log.put_new_line
			end

			log.put_labeled_string ("output.path", output.path.out)
			log.put_new_line
			output.open_write

			output.put_string_32 ({STRING_32}"Optimal fold(s) for " + seq.to_string_32 + ":")
			output.put_new_line

			print_min_fold

			output.put_new_line
			output.put_string ("%NMinimal losses: ")
			output.put_integer (minimum_loss)

			output.close
			log.exit
		end

feature {NONE} -- Implementation

	gen_folds
		deferred
		end

	log_losses (fold: STRING; grid_used_has_zero: BOOLEAN; fold_loss, mininum_loss, fold_list_count: INTEGER)
		do
			if grid_used_has_zero then
				log.put_labeled_string (fold, grid_used_has_zero.out)
				log.put_integer_field (once " fold_loss", fold_loss)
				log.put_integer_field (once " mininum_loss", mininum_loss)
				log.put_integer_field (once " fold_list.count", fold_list_count)
				log.put_new_line
			end
		end

	print_min_fold
		deferred
		end

	print_progress (iteration_count: NATURAL_32)
		do
			if iteration_count \\ Iterations_per_dot = 0 then
				dot_count := dot_count + 1
				lio.put_character ('.')
				if dot_count \\ 100 = 0 then
					lio.put_new_line
				end
			end
		end

feature {NONE} -- Internal attributes

	seq: PF_BOOL_STRING
		deferred
		end

	minimum_loss: INTEGER

	output: EL_PLAIN_TEXT_FILE

	crc: EL_CYCLIC_REDUNDANCY_CHECK_32

	dot_count: NATURAL_32

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 100_000
		end

end