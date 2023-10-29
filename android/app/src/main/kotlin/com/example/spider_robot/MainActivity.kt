package com.example.spider_robot

import android.content.SharedPreferences
import android.content.res.Configuration
import androidx.preference.PreferenceManager
import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        val prefs: SharedPreferences = PreferenceManager.getDefaultSharedPreferences(this)
        val isDarkThemePreference = prefs.getBoolean("is_dark_theme", false)
        val isSystemDarkTheme = (resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK) == Configuration.UI_MODE_NIGHT_YES

        when {
            isDarkThemePreference -> setTheme(R.style.DarkLaunchTheme)
            isSystemDarkTheme -> setTheme(R.style.DarkLaunchTheme)
            else -> setTheme(R.style.LightLaunchTheme)
        }

        super.onCreate(savedInstanceState)
    }
}
