package jadepug.javapainter;

import android.graphics.Color;
import android.graphics.Path;

/**
 * DrawingPath class describes the qualities of a Path.
 *
 * Author: Philip lalonde
 */
public class DrawingPath extends Path {
    int color;
    float lineWidth;

    final int strokeColor = Color.BLACK;
    final float strokeWidth = 30;

    /**
     * Class constructor
     */
    public DrawingPath() {
        this.color = strokeColor;
        this.lineWidth = strokeWidth;
    }
}
