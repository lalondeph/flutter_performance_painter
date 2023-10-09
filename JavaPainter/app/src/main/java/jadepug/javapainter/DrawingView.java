package jadepug.javapainter;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.util.AttributeSet;
import android.view.View;
import androidx.annotation.Nullable;
import java.util.ArrayList;

/**
 * DrawingView provides the methods used to express user input
 * onto the main activity canvas.
 *
 * Author: Philip lalonde
 */
public class DrawingView extends View {

    private final Paint paint = new Paint();
    public ArrayList<DrawingPath> paths = new ArrayList<>();
    private DrawingPath path;

    final int strokeColor = Color.BLACK;
    final float strokeWidth = 30;

    /**
     * Class constructor
     *
     * @param context - DrawingView
     * @param attrs   - dv attributes
     */
    public DrawingView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);

        paint.setColor(strokeColor);
        paint.setStrokeWidth(strokeWidth);

        paint.setAntiAlias(true);
        paint.setDither(true);
        paint.setStyle(Paint.Style.STROKE);
        paint.setStrokeJoin(Paint.Join.ROUND);
        paint.setStrokeCap(Paint.Cap.ROUND);
    }

    /**
     * addPontToPath receives an x and y coordinate and
     * adds them as a point to an a DrawingPath.
     * It's other main function is to cause the screen to be redrawn.
     */
    public void addPointToPath(float x, float y) {
        if (path.isEmpty())
            path.moveTo(x, y);
        else
            path.lineTo(x, y);
        invalidate();
    }

    /**
     * beginPath receives an x and y coordinate and adds a
     * a new DrawingPath with those coordinates to an ArrayList of DrawingPaths.
     */
    public void beginPath() {
        path = new DrawingPath();
        paths.add(path);
    }

    /**
     * onDraw iterates through an ArrayList of and draws
     * each path onto the canvas.
     * It is called automatically when the canvas is redrawn.
     *
     * @param canvas - the drawing canvas
     */
    @Override
    protected void onDraw(Canvas canvas) {
        super.onDraw(canvas);
        for (DrawingPath path : paths) {
            paint.setColor(strokeColor);
            paint.setStrokeWidth(strokeWidth);
            canvas.drawPath(path, paint);
        }
    }
}
