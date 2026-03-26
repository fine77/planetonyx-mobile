package net.planetonyx.store.ui

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import net.planetonyx.store.data.CatalogApp
import net.planetonyx.store.data.CatalogRepository

data class StoreUiState(
    val loading: Boolean = false,
    val apps: List<CatalogApp> = emptyList(),
    val error: String? = null
)

class StoreViewModel(
    private val repository: CatalogRepository = CatalogRepository()
) : ViewModel() {
    private val _state = MutableStateFlow(StoreUiState(loading = true))
    val state: StateFlow<StoreUiState> = _state.asStateFlow()

    init {
        refresh()
    }

    fun refresh() {
        _state.value = _state.value.copy(loading = true, error = null)
        viewModelScope.launch {
            repository.loadCatalog()
                .onSuccess { catalog ->
                    _state.value = StoreUiState(
                        loading = false,
                        apps = catalog.apps.sortedBy { it.name.lowercase() }
                    )
                }
                .onFailure { ex ->
                    _state.value = StoreUiState(
                        loading = false,
                        apps = emptyList(),
                        error = ex.message ?: "Unknown error"
                    )
                }
        }
    }
}

