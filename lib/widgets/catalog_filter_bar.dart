import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/catalog_filter_controller.dart';

class CatalogFilterBar extends StatelessWidget {
  final List<String> genres;

  const CatalogFilterBar({
    super.key,
    required this.genres,
  });

  @override
  Widget build(BuildContext context) {
    final filterController = context.watch<CatalogFilterController>();

    final allGenres = [
      'All',
      ...genres,
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        children: [
          TextField(
            onChanged: filterController.updateSearchQuery,
            controller: TextEditingController(
              text: filterController.searchQuery,
            )..selection = TextSelection.collapsed(
              offset: filterController.searchQuery.length,
            ),
            decoration: InputDecoration(
              hintText: 'Search albums, genres, or tracks...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: filterController.searchQuery.isEmpty
                  ? null
                  : IconButton(
                onPressed: () {
                  filterController.updateSearchQuery('');
                },
                icon: const Icon(Icons.close),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: filterController.selectedGenre,
                  decoration: InputDecoration(
                    labelText: 'Genre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: allGenres.map((genre) {
                    return DropdownMenuItem(
                      value: genre,
                      child: Text(genre),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    filterController.updateGenre(value);
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: DropdownButtonFormField<CatalogSortOption>(
                  value: filterController.sortOption,
                  decoration: InputDecoration(
                    labelText: 'Sort',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: CatalogSortOption.titleAZ,
                      child: Text('Title A-Z'),
                    ),
                    DropdownMenuItem(
                      value: CatalogSortOption.priceLowHigh,
                      child: Text('Price ↑'),
                    ),
                    DropdownMenuItem(
                      value: CatalogSortOption.priceHighLow,
                      child: Text('Price ↓'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    filterController.updateSortOption(value);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: filterController.resetFilters,
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset filters'),
            ),
          ),
        ],
      ),
    );
  }
}