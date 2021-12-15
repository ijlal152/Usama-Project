package com.example.intentassignment

import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.core.app.ShareCompat
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btn1.setOnClickListener{
            var uri=Uri.parse(edit1.text.toString())
            startActivity(Intent(Intent.ACTION_VIEW,uri))
        }
        btn2.setOnClickListener{
            var uri = Uri.parse("tel:"+edit2.text.toString())
            startActivity(Intent(Intent.ACTION_DIAL,uri))
        }
        btn3.setOnClickListener{
            var uri =Uri.parse("geo:O,O?q="+edit3.text.toString())
            startActivity(Intent(Intent.ACTION_VIEW,uri))
        }
        btn4.setOnClickListener{
            ShareCompat.IntentBuilder.from(this)
                .setText(edit4.text.toString())
                .setChooserTitle("sharing Text")
                .setType("text/plain")
                .startChooser()
        }
    }
}