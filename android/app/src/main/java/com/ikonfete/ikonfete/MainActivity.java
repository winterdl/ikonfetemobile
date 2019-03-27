package com.ikonfete.ikonfete;

import android.os.Bundle;

import com.ikonfete.ikonfete.deezer.DeezerChannels;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new DeezerChannels().initialize(this, getFlutterView());
    }
}
