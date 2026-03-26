package net.planetonyx.store.data

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CatalogIndex(
    @SerialName("generated_at") val generatedAt: String? = null,
    @SerialName("store_version") val storeVersion: String? = null,
    val apps: List<CatalogApp> = emptyList()
)

@Serializable
data class CatalogApp(
    val id: String,
    val name: String,
    val channel: String,
    val version: String,
    @SerialName("artifact_url") val artifactUrl: String,
    val sha256: String,
    @SerialName("signature_url") val signatureUrl: String? = null,
    @SerialName("source_repo") val sourceRepo: String? = null,
    val license: String? = null,
    @SerialName("maintainer_mode") val maintainerMode: String? = null
)

