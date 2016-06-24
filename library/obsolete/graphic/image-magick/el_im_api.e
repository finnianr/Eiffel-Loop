note
	description: "Summary description for {IMAGE_MAGICK_CONVERTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:27 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_IM_API

feature {NONE} -- Creation

	frozen c_acquire_exception_info: POINTER
			-- ExceptionInfo *AcquireExceptionInfo(void)
		external
			"C (): EIF_POINTER | <magick/MagickCore.h>"
		alias
			"AcquireExceptionInfo"
		end

	frozen c_acquire_image_info: POINTER
			-- ImageInfo *AcquireImageInfo(void)
		external
			"C (): EIF_POINTER | <magick/MagickCore.h>"
		alias
			"AcquireImageInfo"
		end

	frozen c_new_magick_wand: POINTER
			-- MagickWand *NewMagickWand(void)
		external
			"C (): EIF_POINTER | <wand/MagickWand.h>"
		alias
			"NewMagickWand"
		end

	frozen c_new_pixel_wand: POINTER
			-- PixelWand *NewPixelWand(void)
		external
			"C (): EIF_POINTER | <wand/MagickWand.h>"
		alias
			"NewPixelWand"
		end

--	frozen c_convert_image (argc: INTEGER; argv: POINTER): BOOLEAN
--			-- MagickBooleanType convert_image (int, char **);
--		require
--			at_least_2_arguments: argc >= 2
--			argv_not_null: is_attached (argv)
--		external
--			"C (int, char**): EIF_BOOLEAN | <wand/MagickWand.h>"
--		alias
--			"convert_image"
--		end

feature {NONE} -- Initialization

	frozen c_magick_core_genesis (path: POINTER)
			--	void MagickCoreGenesis(const char *path, const MagickBooleanType establish_signal_handlers)
		external
			"C inline use <magick/MagickCore.h>"
		alias
			"MagickCoreGenesis ((const char *)$path, MagickFalse)"
		end

	frozen c_magick_wand_genesis
			--	void MagickWandGenesis(void)
		external
			"C () | <wand/MagickWand.h>"
		alias
			"MagickWandGenesis"
		end

feature {NONE} -- Magick wand operations

	frozen c_magick_read_image (a_magic_wand_ptr, a_image_path: POINTER): BOOLEAN
			-- MagickBooleanType MagickReadImage (MagickWand *,const char *)
		require
			arg_1_not_null: is_attached (a_magic_wand_ptr)
			arg_2_not_null: is_attached (a_image_path)
		external
			"C (MagickWand *, const char *): EIF_BOOLEAN | <wand/MagickWand.h>"
		alias
			"MagickReadImage"
		ensure
			valid_result: Result
		end

	frozen c_magick_set_image_format (a_magic_wand_ptr, a_format: POINTER): BOOLEAN
			-- MagickBooleanType MagickSetImageFormat(MagickWand *wand, const char *format)
		require
			arg_1_not_null: is_attached (a_magic_wand_ptr)
			arg_2_not_null: is_attached (a_format)
		external
			"C (MagickWand *, const char *): EIF_BOOLEAN | <wand/MagickWand.h>"
		alias
			"MagickSetImageFormat"
		ensure
			valid_result: Result
		end

	frozen c_magick_set_image_background_color (a_magic_wand_ptr, a_color_pixel_wand_ptr: POINTER): BOOLEAN
			-- MagickBooleanType MagickSetImageBackgroundColor (MagickWand *wand,  const PixelWand *background)
		require
			arg_1_not_null: is_attached (a_magic_wand_ptr)
			arg_2_not_null: is_attached (a_color_pixel_wand_ptr)
		external
			"C (MagickWand *, const PixelWand *): EIF_BOOLEAN | <wand/MagickWand.h>"
		alias
			"MagickSetImageBackgroundColor"
		ensure
			valid_result: Result
		end

	frozen c_magick_transparent_paint_image (
		a_magic_wand_ptr, a_pixel_wand_ptr: POINTER; alpha, fuzz: DOUBLE; invert: BOOLEAN
	): BOOLEAN
			-- MagickBooleanType MagickTransparentPaintImage (
			-- 		MagickWand *,const PixelWand *, const double,const double,const MagickBooleanType invert
			-- )
		require
			arg_1_not_null: is_attached (a_magic_wand_ptr)
			arg_2_not_null: is_attached (a_pixel_wand_ptr)
		external
			"C (MagickWand *, const PixelWand*, const double,const double, const MagickBooleanType): EIF_BOOLEAN | <wand/MagickWand.h>"
		alias
			"MagickTransparentPaintImage"
		ensure
			valid_result: Result
		end

	frozen c_magick_flood_fill_paint_image (
		a_magic_wand_ptr: POINTER; a_channel: NATURAL; a_pixel_wand_fill_color_ptr: POINTER; fuzz: DOUBLE
		a_pixel_wand_border_color_ptr: POINTER;	x, y: INTEGER; invert: BOOLEAN
	): BOOLEAN
			-- MagickBooleanType MagickFloodfillPaintImage (
			--     MagickWand *wand, const ChannelType channel, const PixelWand *fill, const double fuzz,
			--     const PixelWand *bordercolor, const ssize_t x, const ssize_t y, const MagickBooleanType invert
			-- )
		require
			wand_not_null: is_attached (a_magic_wand_ptr)
			fill_color_not_null: is_attached (a_pixel_wand_fill_color_ptr)
			border_color_not_null: is_attached (a_pixel_wand_border_color_ptr)
		external
			"[
				C (
					MagickWand *, const ChannelType, const PixelWand *, const double,
					const PixelWand *, const ssize_t, const ssize_t, const MagickBooleanType
				): EIF_BOOLEAN | <wand/MagickWand.h>
			]"
		alias
			"MagickFloodfillPaintImage"
		ensure
			valid_result: Result
		end

	frozen c_magick_transform_image (a_magic_wand_ptr, a_crop_geometry_str, a_size_geometry_str: POINTER): POINTER
			--MagickWand *MagickTransformImage(MagickWand *wand,  const char *crop,const char *geometry)
		require
			arg_1_not_null: is_attached (a_magic_wand_ptr)
			arg_2_not_null: is_attached (a_crop_geometry_str)
			arg_3_not_null: is_attached (a_size_geometry_str)
		external
			"C (MagickWand *, const char *, const char *): EIF_POINTER | <wand/MagickWand.h>"
		alias
			"MagickTransformImage"
		end

	frozen c_magick_flatten_image_layers (a_magic_wand_ptr: POINTER): POINTER
			--MagickWand *MagickMergeImageLayers (MagickWand *, const ImageLayerMethod)
		require
			wand_not_null: is_attached (a_magic_wand_ptr)
		external
			"C inline use <wand/MagickWand.h>"
		alias
			"MagickMergeImageLayers((MagickWand *)$a_magic_wand_ptr, FlattenLayer)"
		end

	frozen c_magick_set_image_alpha_channel (a_magic_wand_ptr: POINTER): BOOLEAN
			-- MagickSetImageAlphaChannel(MagickWand *,const AlphaChannelType)
		require
			wand_not_null: is_attached (a_magic_wand_ptr)
		external
			"C inline use <wand/MagickWand.h>"
		alias
			"MagickSetImageAlphaChannel((MagickWand *)$a_magic_wand_ptr, SetAlphaChannel)"
		end

	frozen c_magick_write_image (a_magic_wand_ptr, a_image_path: POINTER): BOOLEAN
			-- MagickBooleanType MagickWriteImage(MagickWand *wand, const char *filename)
		require
			arg_1_not_null: is_attached (a_magic_wand_ptr)
			arg_2_not_null: is_attached (a_image_path)
		external
			"C (MagickWand *, const char *): EIF_BOOLEAN | <wand/MagickWand.h>"
		alias
			"MagickWriteImage"
		ensure
			valid_result: Result
		end

feature {NONE} -- Pixel Wand operations

	frozen c_pixel_set_color (a_pixel_wand_ptr, a_color_spec: POINTER): BOOLEAN
			-- MagickBooleanType PixelSetColor(PixelWand *, const char *)
		require
			arg_1_not_null: is_attached (a_pixel_wand_ptr)
			arg_2_not_null: is_attached (a_color_spec)
		external
			"C (PixelWand *, const char *): EIF_BOOLEAN | <wand/MagickWand.h>"
		alias
			"PixelSetColor"
		ensure
			valid_result: Result
		end

feature {NONE} -- Constants

	frozen c_alpha_channel: NATURAL
			--	
		external
			"C inline use <wand/MagickWand.h>"
		alias
			"AlphaChannel"
		end

	frozen c_RGB_channels: NATURAL
			--	
		external
			"C inline use <wand/MagickWand.h>"
		alias
			"RGBChannels"
		end

	frozen c_all_channels: NATURAL
			--	
		external
			"C inline use <wand/MagickWand.h>"
		alias
			"AllChannels"
		end

	frozen c_undefined_channel: NATURAL
			--	
		external
			"C inline use <wand/MagickWand.h>"
		alias
			"UndefinedChannel"
		end

feature -- Disposal

	frozen c_magick_core_terminus
			-- void MagickCoreTerminus(void)
		external
			"C () | <magick/MagickCore.h>"
		alias
			"MagickCoreTerminus"
		end

	frozen c_magick_wand_terminus
			-- void MagickWandTerminus(void)
		external
			"C () | <magick/MagickCore.h>"
		alias
			"MagickWandTerminus"
		end

	frozen c_destroy_image_info (a_image_info_ptr: POINTER): POINTER
			-- ImageInfo *DestroyImageInfo(ImageInfo *)
		require
			pointer_not_null: is_attached (a_image_info_ptr)
		external
			"C (ImageInfo *): EIF_POINTER | <magick/MagickCore.h>"
		alias
			"DestroyImageInfo"
		end

	frozen c_destroy_exception_info (a_exception_info_ptr: POINTER): POINTER
			-- ExceptionInfo *DestroyExceptionInfo(ExceptionInfo *)
		require
			pointer_not_null: is_attached (a_exception_info_ptr)
		external
			"C (ExceptionInfo *): EIF_POINTER | <magick/MagickCore.h>"
		alias
			"DestroyExceptionInfo"
		end

	frozen c_destroy_magick_wand (a_magic_wand_ptr: POINTER): POINTER
			-- MagickWand *DestroyMagickWand(MagickWand *)
		require
			pointer_not_null: is_attached (a_magic_wand_ptr)
		external
			"C (MagickWand *): EIF_POINTER | <wand/MagickWand.h>"
		alias
			"DestroyMagickWand"
		end

	frozen c_destroy_pixel_wand (a_magic_wand_ptr: POINTER): POINTER
			-- PixelWand *DestroyPixelWand(PixelWand *)
		require
			pointer_not_null: is_attached (a_magic_wand_ptr)
		external
			"C (PixelWand *): EIF_POINTER | <wand/MagickWand.h>"
		alias
			"DestroyPixelWand"
		end

	frozen c_clear_magick_wand (a_magic_wand_ptr: POINTER)
			-- void ClearMagickWand(MagickWand *wand)
		require
			pointer_not_null: is_attached (a_magic_wand_ptr)
		external
			"C (MagickWand *) | <wand/MagickWand.h>"
		alias
			"ClearMagickWand"
		end

feature {NONE} -- Exception_info

    frozen c_exception_severity (image_info: POINTER): INTEGER
            --
		require
			not_null_pointer: is_attached (image_info)
        external
            "C [struct <magick/MagickCore.h>] (ExceptionInfo): EIF_INTEGER"
        alias
            "severity"
        end

end
