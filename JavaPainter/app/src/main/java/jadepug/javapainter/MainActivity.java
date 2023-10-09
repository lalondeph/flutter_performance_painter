package jadepug.javapainter;

import android.annotation.SuppressLint;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.view.MotionEvent;

import androidx.annotation.RequiresApi;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.floatingactionbutton.FloatingActionButton;

/**
 * MainActivity hosts the running logic for the app.
 * Here we define elements on the screen and
 * capture / apply user input
 *
 * Author: Philip lalonde
 */
public class MainActivity extends AppCompatActivity {

    private DrawingView dv;

    /**
     * onCreate links variables with on-screen elements and
     * assigns them to various listeners. It also sets the initial
     * value for variables the user will later reassign.
     *
     * @param savedInstanceState : A mapping from String keys to various Parcelable values
     */
    @RequiresApi(api = Build.VERSION_CODES.Q)
    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        dv = findViewById(R.id.drawingView);
        dv.setDrawingCacheEnabled(true);
        dv.setBackgroundColor(Color.parseColor("#FFFAFAFA"));


        FloatingActionButton btnClear = findViewById(R.id.btnClear);

        /*
         * This listener clears out the paths Arraylist
         * and prompts the canvas to redraw
         */
        btnClear.setOnClickListener(view -> {
            dv.paths.clear();
            dv.invalidate();
        });

        /*
         * Called on user touch event. This listener
         * turns touch input into points on a path.
         */
        dv.setOnTouchListener((view, motionEvent) -> {
            float x = motionEvent.getX();
            float y = motionEvent.getY();
            int action = motionEvent.getActionMasked();

            if(action == MotionEvent.ACTION_DOWN) {
                dv.beginPath();
            }

            dv.addPointToPath(x, y);
            return true;
        });
    }
}