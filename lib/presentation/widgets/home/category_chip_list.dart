import 'package:flutter/material.dart';

import '../../../constants/app_constants.dart';
import '../../../cubit/movie_cubit.dart';
import 'category_chip.dart';

class CategoryChipList extends StatelessWidget {
  const CategoryChipList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.paddingSmall,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
        ),
        children: [
          CategoryChip(label: 'Popüler', category: MovieCategory.popular),
          CategoryChip(label: 'Trend', category: MovieCategory.trending),
          CategoryChip(label: 'Vizyonda', category: MovieCategory.nowPlaying),
          CategoryChip(label: 'Yakında', category: MovieCategory.upcoming),
          CategoryChip(label: 'En İyi', category: MovieCategory.topRated),
        ],
      ),
    );
  }
}
