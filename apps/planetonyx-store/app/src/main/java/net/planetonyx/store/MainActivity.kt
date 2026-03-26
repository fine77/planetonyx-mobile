package net.planetonyx.store

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import net.planetonyx.store.ui.StoreApp
import net.planetonyx.store.ui.theme.PlanetonyxStoreTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            PlanetonyxStoreTheme {
                StoreApp()
            }
        }
    }
}

