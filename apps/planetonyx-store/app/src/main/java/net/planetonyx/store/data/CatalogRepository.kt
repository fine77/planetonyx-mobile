package net.planetonyx.store.data

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import okhttp3.OkHttpClient
import okhttp3.Request

class CatalogRepository(
    private val baseUrl: String = "https://appstore.srv.planetonyx.net",
    private val http: OkHttpClient = OkHttpClient(),
    private val json: Json = Json { ignoreUnknownKeys = true }
) {
    suspend fun loadCatalog(): Result<CatalogIndex> = withContext(Dispatchers.IO) {
        runCatching {
            val request = Request.Builder()
                .url("${baseUrl.trimEnd('/')}/index.json")
                .get()
                .build()
            http.newCall(request).execute().use { response ->
                if (!response.isSuccessful) {
                    error("Catalog request failed: HTTP ${response.code}")
                }
                val body = response.body?.string().orEmpty()
                if (body.isBlank()) {
                    error("Catalog response is empty")
                }
                json.decodeFromString<CatalogIndex>(body)
            }
        }
    }
}

