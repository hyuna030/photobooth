package com.example.photoprogram;

import java.io.InputStream;
import java.net.URL;
import java.util.Base64;

public class ImageUtil {

    public static String convertImageToBase64(String imageUrl) {
        try (InputStream in = new URL(imageUrl).openStream()) {
            byte[] bytes = in.readAllBytes();
            String base64 = Base64.getEncoder().encodeToString(bytes);
            return "data:image/png;base64," + base64;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
