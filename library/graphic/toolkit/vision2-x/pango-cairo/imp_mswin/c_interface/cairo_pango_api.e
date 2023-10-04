note
	description: "Pango API"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	CAIRO_PANGO_API

inherit
	EL_DYNAMIC_MODULE [CAIRO_PANGO_API_POINTERS]

	CAIRO_PANGO_I

	CAIRO_PANGO_C_API

create
	make

feature -- Access

	layout_indent (layout: POINTER): INTEGER
		do
			Result := pango_layout_get_indent (api.layout_get_indent, layout)
		end

	layout_pango_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_size (api.layout_get_size, layout, $width, $height)
			Result := [width, height]
		end

	layout_size (layout: POINTER): TUPLE [width, height: INTEGER]
		local
			width, height: INTEGER
		do
			pango_layout_get_pixel_size (api.layout_get_pixel_size, layout, $width, $height)
			Result := [width, height]
		end

	layout_text (layout: POINTER): POINTER
		do
			Result := pango_layout_get_text (api.layout_get_text, layout)
		end

feature -- Factory

	new_font (pango_context, font_description: POINTER): POINTER
		do
			Result := pango_context_load_font (api.context_load_font, pango_context, font_description)
		end

	new_font_description: POINTER
		do
			Result := pango_font_description_new (api.font_description_new)
		end

	new_font_description_from_string (str: POINTER): POINTER
		do
			Result := pango_font_description_from_string (api.font_description_from_string, str)
		end

feature -- Element change

	set_context_font_description (a_context, font_description: POINTER)
		-- set Pango `a_context' with `font_description'
		do
			pango_context_set_font_description (api.context_set_font_description, a_context, font_description)
		end

	set_font_absolute_size (font_description: POINTER; size: DOUBLE)
		do
			pango_font_description_set_absolute_size (api.font_description_set_absolute_size, font_description, size)
		end

	set_font_family (font_description: POINTER; a_family: POINTER)
		do
			pango_font_description_set_family (api.font_description_set_family, font_description, a_family)
		end

	set_font_stretch (font_description: POINTER; value: INTEGER)
		do
			pango_font_description_set_stretch (api.font_description_set_stretch, font_description, value)
		end

	set_font_style (font_description: POINTER; a_style: INTEGER_32)
		do
			pango_font_description_set_style (api.font_description_set_style, font_description, a_style)
		end

	set_font_weight (font_description: POINTER; a_weight: INTEGER_32)
		do
			pango_font_description_set_weight (api.font_description_set_weight, font_description, a_weight)
		end

	set_font_size (font_description: POINTER; a_size: INTEGER_32)
		do
			pango_font_description_set_size (api.font_description_set_size, font_description, a_size)
		end

	set_layout_text (a_layout: POINTER; a_text: POINTER; a_length: INTEGER_32)
		do
			pango_layout_set_text (api.layout_set_text, a_layout, a_text, a_length)
		end

	set_layout_font_description (a_layout, font_description: POINTER)
		do
			pango_layout_set_font_description (api.layout_set_font_description, a_layout, font_description)
		end

	set_layout_width (a_layout: POINTER; a_width: INTEGER_32)
		do
			pango_layout_set_width (api.layout_set_width, a_layout, a_width)
		end

feature -- Memory release

	font_description_free (font_description: POINTER)
		do
			pango_font_description_free (api.font_description_free, font_description)
		end

feature {NONE} -- Constants

	Module_name: STRING = "libpango-1.0-0"

	Name_prefix: STRING = "pango_"

note
	library_functions: "[
		dumpbin /EXPORTS Cairo-1.12.16\spec\win64\libpango-1.0-0.dll
		
		 1    0 0002D458 pango_alignment_get_type
		 2    1 0000BF45 pango_attr_background_new
		 3    2 0000C4E7 pango_attr_fallback_new
		 4    3 0000BCCB pango_attr_family_new
		 5    4 0000C3B7 pango_attr_font_desc_new
		 6    5 0000BF0A pango_attr_foreground_new
		 7    6 0000C879 pango_attr_gravity_hint_new
		 8    7 0000C834 pango_attr_gravity_new
		 9    8 0000D6F0 pango_attr_iterator_copy
		10    9 0000D76E pango_attr_iterator_destroy
		11    A 0000D7BD pango_attr_iterator_get
		12    B 0000DD7B pango_attr_iterator_get_attrs
		13    C 0000D83B pango_attr_iterator_get_font
		14    D 0000D52A pango_attr_iterator_next
		15    E 0000D4AB pango_attr_iterator_range
		16    F 0000BD7D pango_attr_language_new
		17   10 0000C503 pango_attr_letter_spacing_new
		18   11 0000CD7A pango_attr_list_change
		19   12 0000CA54 pango_attr_list_copy
		20   13 0000DC2A pango_attr_list_filter
		21   14 0000D417 pango_attr_list_get_iterator
		22   15 0000C897 pango_attr_list_get_type
		23   16 0000CC9E pango_attr_list_insert
		24   17 0000CD0C pango_attr_list_insert_before
		25   18 0000C936 pango_attr_list_new
		26   19 0000C974 pango_attr_list_ref
		27   1A 0000D1D4 pango_attr_list_splice
		28   1B 0000C998 pango_attr_list_unref
		29   1C 0000C4AB pango_attr_rise_new = pango_attr_iterator_range
		30   1D 0000C4C7 pango_attr_scale_new
		31   1E 0000C7AD pango_attr_shape_new
		32   1F 0000C6C9 pango_attr_shape_new_with_data
		33   20 0000C238 pango_attr_size_new
		34   21 0000C252 pango_attr_size_new_absolute
		35   22 0000C2C6 pango_attr_stretch_new
		36   23 0000C470 pango_attr_strikethrough_color_new
		37   24 0000C454 pango_attr_strikethrough_new
		38   25 0000C26C pango_attr_style_new
		39   26 0000B9D9 pango_attr_type_get_name
		40   27 0002CF00 pango_attr_type_get_type
		41   28 0000B951 pango_attr_type_register
		42   29 0000C419 pango_attr_underline_color_new
		43   2A 0000C3FB pango_attr_underline_new
		44   2B 0000C2A8 pango_attr_variant_new
		45   2C 0000C28A pango_attr_weight_new
		46   2D 0000BAA8 pango_attribute_copy
		47   2E 0000BB13 pango_attribute_destroy
		48   2F 0000BB55 pango_attribute_equal
		49   30 0000BA2F pango_attribute_init
		50   31 0000DE40 pango_bidi_type_for_unichar
		51   32 0002CFE4 pango_bidi_type_get_type
		52   33 00003818 pango_break
		53   34 0000E500 pango_color_copy
		54   35 0000E542 pango_color_free
		55   36 0000E461 pango_color_get_type
		56   37 0000E894 pango_color_parse
		57   38 0000E568 pango_color_to_string
		58   39 0002B98E pango_config_key_get
		59   3A 0002B923 pango_config_key_get_system
		60   3B 00011E30 pango_context_changed
		61   3C 0000F7E7 pango_context_get_base_dir
		62   3D 0000F880 pango_context_get_base_gravity
		63   3E 0000F69E pango_context_get_font_description
		64   3F 0000F3AC pango_context_get_font_map
		65   40 0000F8BD pango_context_get_gravity
		66   41 0000F94D pango_context_get_gravity_hint
		67   42 0000F756 pango_context_get_language
		68   43 0000F198 pango_context_get_matrix
		69   44 00011C50 pango_context_get_metrics
		70   45 00011E9B pango_context_get_serial
		71   46 0000EE05 pango_context_get_type
		72   47 0000F443 pango_context_list_families
		73   48 0000F4F9 pango_context_load_font
		74   49 0000F57C pango_context_load_fontset
		75   4A 0000F039 pango_context_new
		76   4B 0000F794 pango_context_set_base_dir
		77   4C 0000F824 pango_context_set_base_gravity
		78   4D 0000F5DC pango_context_set_font_description
		79   4E 0000F22F pango_context_set_font_map
		80   4F 0000F8FA pango_context_set_gravity_hint
		81   50 0000F6DC pango_context_set_language
		82   51 0000F09E pango_context_set_matrix
		83   52 00011F12 pango_coverage_copy
		84   53 00012D16 pango_coverage_from_bytes
		85   54 000121A2 pango_coverage_get
		86   55 0002D0C8 pango_coverage_level_get_type
		87   56 0001254E pango_coverage_max
		88   57 00011EC0 pango_coverage_new
		89   58 0001208E pango_coverage_ref
		90   59 000122B1 pango_coverage_set
		91   5A 00012A1C pango_coverage_to_bytes
		92   5B 000120D0 pango_coverage_unref
		93   5C 00001781 pango_default_break
		94   5D 0002D056 pango_direction_get_type
		95   5E 0002D53C pango_ellipsize_mode_get_type
		96   5F 00013205 pango_engine_get_type
		97   60 00013301 pango_engine_lang_get_type
		98   61 00013454 pango_engine_shape_get_type
		99   62 0002C000 pango_extents_to_pixels
		100   63 0002BD9D pango_find_base_dir
		101   64 0000A1AD pango_find_map
		102   65 000038C3 pango_find_paragraph_boundary
		103   66 00007DDE pango_font_describe
		104   67 00007E28 pango_font_describe_with_absolute_size
		105   68 000064EE pango_font_description_better_match
		106   69 000065D5 pango_font_description_copy
		107   6A 00006664 pango_font_description_copy_static
		108   6B 000066DA pango_font_description_equal
		109   6C 000069A1 pango_font_description_free
		110   6D 00007179 pango_font_description_from_string
		111   6E 00005C74 pango_font_description_get_family
		112   6F 00006108 pango_font_description_get_gravity
		113   70 00006146 pango_font_description_get_set_fields
		114   71 00005F78 pango_font_description_get_size
		115   72 0000604F pango_font_description_get_size_is_absolute
		116   73 00005EB7 pango_font_description_get_stretch
		117   74 00005D04 pango_font_description_get_style
		118   75 000059E5 pango_font_description_get_type
		119   76 00005D95 pango_font_description_get_variant
		120   77 00005E26 pango_font_description_get_weight
		121   78 000068D7 pango_font_description_hash
		122   79 00006243 pango_font_description_merge
		123   7A 000062F6 pango_font_description_merge_static
		124   7B 00005A84 pango_font_description_new
		125   7C 00005FB6 pango_font_description_set_absolute_size
		126   7D 00005B13 pango_font_description_set_family
		127   7E 00005B83 pango_font_description_set_family_static
		128   7F 0000609F pango_font_description_set_gravity
		129   80 00005EF5 pango_font_description_set_size
		130   81 00005E64 pango_font_description_set_stretch
		131   82 00005CB1 pango_font_description_set_style
		132   83 00005D42 pango_font_description_set_variant
		133   84 00005DD3 pango_font_description_set_weight
		134   85 0000791F pango_font_description_to_filename
		135   86 000075F5 pango_font_description_to_string
		136   87 0000618C pango_font_description_unset_fields
		137   88 000069F1 pango_font_descriptions_free
		138   89 0000886A pango_font_face_describe
		139   8A 000089CA pango_font_face_get_face_name
		140   8B 000087B2 pango_font_face_get_type
		141   8C 0000890D pango_font_face_is_synthesized
		142   8D 00008A6D pango_font_face_list_sizes
		143   8E 00008554 pango_font_family_get_name
		144   8F 0000849C pango_font_family_get_type
		145   90 000086B1 pango_font_family_is_monospace
		146   91 000085F7 pango_font_family_list_faces
		147   92 00007F03 pango_font_find_shaper
		148   93 00007EA8 pango_font_get_coverage
		149   94 000080D5 pango_font_get_font_map
		150   95 00007F70 pango_font_get_glyph_extents
		151   96 00008034 pango_font_get_metrics
		152   97 00007D26 pango_font_get_type
		153   98 000145A7 pango_font_map_changed
		154   99 00013E9F pango_font_map_create_context
		155   9A 000144EA pango_font_map_get_serial
		156   9B 0001444D pango_font_map_get_shape_engine_type
		157   9C 00013DD5 pango_font_map_get_type
		158   9D 00013F58 pango_font_map_list_families
		159   9E 00013EF2 pango_font_map_load_font
		160   9F 00013FB9 pango_font_map_load_fontset
		161   A0 0002D302 pango_font_mask_get_type
		162   A1 000082EA pango_font_metrics_get_approximate_char_width
		163   A2 00008327 pango_font_metrics_get_approximate_digit_width
		164   A3 00008270 pango_font_metrics_get_ascent
		165   A4 000082AD pango_font_metrics_get_descent
		166   A5 000083DE pango_font_metrics_get_strikethrough_position
		167   A6 0000841B pango_font_metrics_get_strikethrough_thickness
		168   A7 0000811F pango_font_metrics_get_type
		169   A8 00008364 pango_font_metrics_get_underline_position
		170   A9 000083A1 pango_font_metrics_get_underline_thickness
		171   AA 000081BE pango_font_metrics_new
		172   AB 000081E4 pango_font_metrics_ref
		173   AC 00008208 pango_font_metrics_unref
		174   AD 00014BD3 pango_fontset_foreach
		175   AE 00014A7F pango_fontset_get_font
		176   AF 00014B30 pango_fontset_get_metrics
		177   B0 000149B5 pango_fontset_get_type
		178   B1 00015222 pango_fontset_simple_append
		179   B2 00014FF3 pango_fontset_simple_get_type
		180   B3 00014F7B pango_fontset_simple_new
		181   B4 0001525D pango_fontset_simple_size
		182   B5 0002BAA6 pango_get_lib_subdirectory
		183   B6 00003C13 pango_get_log_attrs
		184   B7 0000E130 pango_get_mirror_char
		185   B8 0002BA0F pango_get_sysconf_subdirectory
		186   B9 000166A7 pango_glyph_item_apply_attrs
		187   BA 00015C58 pango_glyph_item_copy
		188   BB 00015CB4 pango_glyph_item_free
		189   BC 00016BAB pango_glyph_item_get_logical_widths
		190   BD 00015D12 pango_glyph_item_get_type
		191   BE 00015DB1 pango_glyph_item_iter_copy
		192   BF 00015E0D pango_glyph_item_iter_free
		193   C0 00015E33 pango_glyph_item_iter_get_type
		194   C1 0001647E pango_glyph_item_iter_init_end
		195   C2 000163D0 pango_glyph_item_iter_init_start
		196   C3 00015ED2 pango_glyph_item_iter_next_cluster
		197   C4 00016151 pango_glyph_item_iter_prev_cluster
		198   C5 0001692B pango_glyph_item_letter_space
		199   C6 000157A1 pango_glyph_item_split
		200   C7 000090B4 pango_glyph_string_copy
		201   C8 000094CE pango_glyph_string_extents
		202   C9 000091AE pango_glyph_string_extents_range
		203   CA 00009168 pango_glyph_string_free
		204   CB 0000956E pango_glyph_string_get_logical_widths
		205   CC 00009015 pango_glyph_string_get_type
		206   CD 00009518 pango_glyph_string_get_width
		207   CE 0000960B pango_glyph_string_index_to_x
		208   CF 00008EA1 pango_glyph_string_new
		209   D0 00008EEA pango_glyph_string_set_size
		210   D1 00009999 pango_glyph_string_x_to_index
		211   D2 00016D7D pango_gravity_get_for_matrix
		212   D3 00016E84 pango_gravity_get_for_script
		213   D4 00016ED0 pango_gravity_get_for_script_and_width
		214   D5 0002D374 pango_gravity_get_type
		215   D6 0002D3E6 pango_gravity_hint_get_type
		216   D7 00016CF0 pango_gravity_to_rotation
		217   D8 0002BE58 pango_is_zero_width
		218   D9 000172CD pango_item_copy
		219   DA 000173DA pango_item_free
		220   DB 00017457 pango_item_get_type
		221   DC 000172B1 pango_item_new
		222   DD 000174F6 pango_item_split
		223   DE 000118D6 pango_itemize
		224   DF 000116A5 pango_itemize_with_base_dir
		225   E0 00017CB8 pango_language_from_string
		226   E1 00017C40 pango_language_get_default
		227   E2 00018159 pango_language_get_sample_string
		228   E3 000181E0 pango_language_get_scripts
		229   E4 00017B23 pango_language_get_type
		230   E5 000182C7 pango_language_includes_script
		231   E6 00017E16 pango_language_matches
		232   E7 00017E08 pango_language_to_string
		233   E8 0001A3C7 pango_layout_context_changed
		234   E9 00018CD3 pango_layout_copy
		235   EA 00019802 pango_layout_get_alignment
		236   EB 00019350 pango_layout_get_attributes
		237   EC 000196F2 pango_layout_get_auto_dir
		238   ED 0001C910 pango_layout_get_baseline
		239   EE 00019F6C pango_layout_get_character_count
		240   EF 00018E25 pango_layout_get_context
		241   F0 0001BC7C pango_layout_get_cursor_pos
		242   F1 00019C3E pango_layout_get_ellipsize
		243   F2 0001C759 pango_layout_get_extents
		244   F3 000194B3 pango_layout_get_font_description
		245   F4 00018F9A pango_layout_get_height
		246   F5 000191EF pango_layout_get_indent
		247   F6 00021900 pango_layout_get_iter
		248   F7 000195D5 pango_layout_get_justify
		249   F8 0001A688 pango_layout_get_line
		250   F9 0001A5B0 pango_layout_get_line_count
		251   FA 0001A71A pango_layout_get_line_readonly
		252   FB 0001A5F9 pango_layout_get_lines
		253   FC 0001A666 pango_layout_get_lines_readonly
		254   FD 0001A486 pango_layout_get_log_attrs
		255   FE 0001A53A pango_layout_get_log_attrs_readonly
		256   FF 0001C7AF pango_layout_get_pixel_extents
		257  100 0001C8C5 pango_layout_get_pixel_size
		258  101 0001A468 pango_layout_get_serial
		259  102 00019ABA pango_layout_get_single_paragraph_mode
		260  103 0001C87A pango_layout_get_size
		261  104 0001927F pango_layout_get_spacing
		262  105 0001992C pango_layout_get_tabs
		263  106 00019EBF pango_layout_get_text
		264  107 000189D2 pango_layout_get_type
		265  108 0001A1C6 pango_layout_get_unknown_glyphs_count
		266  109 00018EC3 pango_layout_get_width
		267  10A 000190AF pango_layout_get_wrap
		268  10B 0001ABE2 pango_layout_index_to_line_x
		269  10C 0001B527 pango_layout_index_to_pos
		270  10D 00019CDB pango_layout_is_ellipsized
		271  10E 0001914F pango_layout_is_wrapped
		272  10F 00021C75 pango_layout_iter_at_last_line
		273  110 0002168F pango_layout_iter_copy
		274  111 00021ACD pango_layout_iter_free
		275  112 00022774 pango_layout_iter_get_baseline
		276  113 0002226F pango_layout_iter_get_char_extents
		277  114 00022359 pango_layout_iter_get_cluster_extents
		278  115 00021B3F pango_layout_iter_get_index
		279  116 00021CB3 pango_layout_iter_get_layout
		280  117 000227B2 pango_layout_iter_get_layout_extents
		281  118 00021C03 pango_layout_iter_get_line
		282  119 000225CF pango_layout_iter_get_line_extents
		283  11A 00021C44 pango_layout_iter_get_line_readonly
		284  11B 0002267E pango_layout_iter_get_line_yrange
		285  11C 00021B6F pango_layout_iter_get_run
		286  11D 000224A2 pango_layout_iter_get_run_extents
		287  11E 00021BB0 pango_layout_iter_get_run_readonly
		288  11F 00021861 pango_layout_iter_get_type
		289  120 00021EA8 pango_layout_iter_next_char
		290  121 00022039 pango_layout_iter_next_cluster
		291  122 00022133 pango_layout_iter_next_line
		292  123 00022055 pango_layout_iter_next_run
		293  124 0001FBCD pango_layout_line_get_extents
		294  125 0001FFFA pango_layout_line_get_pixel_extents
		295  126 0001EB00 pango_layout_line_get_type
		296  127 0001F0E5 pango_layout_line_get_x_ranges
		297  128 0001A7A0 pango_layout_line_index_to_x
		298  129 0001EA23 pango_layout_line_ref
		299  12A 0001EA57 pango_layout_line_unref
		300  12B 0001EB9F pango_layout_line_x_to_index
		301  12C 0001AD31 pango_layout_move_cursor_visually
		302  12D 00018C5E pango_layout_new
		303  12E 00019792 pango_layout_set_alignment
		304  12F 000192BC pango_layout_set_attributes
		305  130 00019619 pango_layout_set_auto_dir
		306  131 00019B5A pango_layout_set_ellipsize
		307  132 000193E7 pango_layout_set_font_description
		308  133 00018F00 pango_layout_set_height
		309  134 0001919C pango_layout_set_indent
		310  135 0001954A pango_layout_set_justify
		311  136 0001A002 pango_layout_set_markup
		312  137 0001A03D pango_layout_set_markup_with_accel
		313  138 000199DF pango_layout_set_single_paragraph_mode
		314  139 0001922C pango_layout_set_spacing
		315  13A 00019848 pango_layout_set_tabs
		316  13B 00019D2B pango_layout_set_text
		317  13C 00018E63 pango_layout_set_width
		318  13D 00018FD7 pango_layout_set_wrap
		319  13E 0001B2DF pango_layout_xy_to_index
		320  13F 0000E047 pango_log2vis_get_embedding_levels
		321  140 0002BD76 pango_lookup_aliases
		322  141 0000B346 pango_map_get_engine
		323  142 0000B4B7 pango_map_get_engines
		324  143 0002388B pango_markup_parser_finish
		325  144 0002382D pango_markup_parser_new
		326  145 0002683A pango_matrix_concat
		327  146 000265B0 pango_matrix_copy
		328  147 00026614 pango_matrix_free
		329  148 000269DA pango_matrix_get_font_scale_factor
		330  149 00026511 pango_matrix_get_type
		331  14A 0002677D pango_matrix_rotate
		332  14B 000266E8 pango_matrix_scale
		333  14C 00026B0A pango_matrix_transform_distance
		334  14D 00026EB5 pango_matrix_transform_pixel_rectangle
		335  14E 00026BA2 pango_matrix_transform_point
		336  14F 00026C10 pango_matrix_transform_rectangle
		337  150 0002663A pango_matrix_translate
		338  151 0000B5EC pango_module_register
		339  152 0002BBDA pango_parse_enum
		340  153 000236E6 pango_parse_markup
		341  154 00007C9F pango_parse_stretch
		342  155 00007BD6 pango_parse_style
		343  156 00007C19 pango_parse_variant
		344  157 00007C5C pango_parse_weight
		345  158 0002BED4 pango_quantize_line_geometry
		346  159 0002AFB4 pango_read_line
		347  15A 0002D5AE pango_render_part_get_type = compact_list
		348  15B 000292E8 pango_renderer_activate
		349  15C 0002935D pango_renderer_deactivate
		350  15D 00028D24 pango_renderer_draw_error_underline
		351  15E 0002922B pango_renderer_draw_glyph
		352  15F 00028657 pango_renderer_draw_glyph_item
		353  160 000284F5 pango_renderer_draw_glyphs
		354  161 00027768 pango_renderer_draw_layout
		355  162 00027F6C pango_renderer_draw_layout_line
		356  163 00028764 pango_renderer_draw_rectangle
		357  164 0002915B pango_renderer_draw_trapezoid
		358  165 00029599 pango_renderer_get_color
		359  166 000299BE pango_renderer_get_layout
		360  167 000299EF pango_renderer_get_layout_line
		361  168 00029927 pango_renderer_get_matrix
		362  169 000275B7 pango_renderer_get_type
		363  16A 00029635 pango_renderer_part_changed
		364  16B 000293F9 pango_renderer_set_color
		365  16C 000298CE pango_renderer_set_matrix
		366  16D 0002C400 pango_reorder_items
		367  16E 0002B4C3 pango_scan_int
		368  16F 0002B30E pango_scan_string
		369  170 0002B1D9 pango_scan_word
		370  171 00029A10 pango_script_for_unichar
		371  172 00018594 pango_script_get_sample_language
		372  173 0002D620 pango_script_get_type
		373  174 00029AF2 pango_script_iter_free
		374  175 00029B17 pango_script_iter_get_range
		375  176 00029ABB pango_script_iter_new
		376  177 00029C00 pango_script_iter_next
		377  178 0002C921 pango_shape
		378  179 0002C964 pango_shape_full
		379  17A 0002B175 pango_skip_space
		380  17B 0002AE81 pango_split_file_list
		381  17C 0002D290 pango_stretch_get_type
		382  17D 0002D13A pango_style_get_type
		383  17E 0002D692 pango_tab_align_get_type
		384  17F 0002A4C7 pango_tab_array_copy
		385  180 0002A544 pango_tab_array_free
		386  181 0002A955 pango_tab_array_get_positions_in_pixels
		387  182 0002A593 pango_tab_array_get_size
		388  183 0002A779 pango_tab_array_get_tab
		389  184 0002A84A pango_tab_array_get_tabs
		390  185 0002A428 pango_tab_array_get_type
		391  186 0002A267 pango_tab_array_new
		392  187 0002A325 pango_tab_array_new_with_positions
		393  188 0002A5CF pango_tab_array_resize
		394  189 0002A67E pango_tab_array_set_tab
		395  18A 0002ADAF pango_trim_string
		396  18B 0002CF72 pango_underline_get_type
		397  18C 0000E0F1 pango_unichar_direction
		398  18D 0002BFB1 pango_units_from_double
		399  18E 0002BFE6 pango_units_to_double
		400  18F 0002D1AC pango_variant_get_type
		401  190 0002AD35 pango_version
		402  191 0002AD4D pango_version_check
		403  192 0002AD40 pango_version_string
		404  193 0002D21E pango_weight_get_type
		405  194 0002D4CA pango_wrap_mode_get_type
	]"
end
