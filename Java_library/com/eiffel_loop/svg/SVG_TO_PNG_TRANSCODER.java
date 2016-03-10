package com.eiffel_loop.svg;

import java.io.*;

import java.awt.*;

import org.apache.batik.transcoder.image.PNGTranscoder;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;

public class SVG_TO_PNG_TRANSCODER extends PNGTranscoder {

	public void set_width (int width){
        addTranscodingHint (PNGTranscoder.KEY_WIDTH, new Float (width));
	}
	public void set_height (int height){
        addTranscodingHint (PNGTranscoder.KEY_HEIGHT, new Float (height));
	}
	public void set_background_color (Color color){
        addTranscodingHint (PNGTranscoder.KEY_BACKGROUND_COLOR, color);
	}

	public void set_background_color_with_24_bit_rgb (int rgb_24_bit){
        set_background_color (new Color (rgb_24_bit));
	}

	public void transcode (String input_path, String output_path) throws Exception {
		File input_file = new File (input_path);
        TranscoderInput input = new TranscoderInput (input_file.toURL().toString());

        // Create the transcoder output.
        FileOutputStream ostream = new FileOutputStream (output_path);
        TranscoderOutput output = new TranscoderOutput (ostream);

        // Save the image.
        transcode (input, output);

        // Flush and close the stream.
        ostream.flush();
        ostream.close();
    }

}
