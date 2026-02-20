import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/custom_app_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/responsive_container.dart';
import '../blog/data/blog_repository.dart';
import '../blog/models/blog_post_model.dart';

final postBySlugProvider = FutureProvider.family<BlogPostModel?, String>((
  ref,
  slug,
) async {
  return BlogRepository().fetchPostBySlug(slug);
});

class BlogDetailPage extends ConsumerWidget {
  final String slug;
  const BlogDetailPage({super.key, required this.slug});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postBySlugProvider(slug));

    return Scaffold(
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            postAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(80),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (_, __) => Padding(
                padding: const EdgeInsets.all(80),
                child: Text('Post not found.', style: AppTypography.bodyLarge),
              ),
              data: (post) {
                if (post == null)
                  return Padding(
                    padding: const EdgeInsets.all(80),
                    child: Text(
                      'Post not found.',
                      style: AppTypography.bodyLarge,
                    ),
                  );
                return Column(
                  children: [
                    if (post.imageUrl != null)
                      AspectRatio(
                        aspectRatio: 16 / 6,
                        child: CachedNetworkImage(
                          imageUrl: post.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              Container(color: AppColors.secondary),
                        ),
                      ),
                    const SizedBox(height: 48),
                    ResponsiveContainer(
                      maxWidth: 800,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Formatters.formatDate(post.createdAt),
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 12),
                          Text(post.title, style: AppTypography.displaySmall),
                          const SizedBox(height: 24),
                          if (post.content != null)
                            Text(post.content!, style: AppTypography.bodyLarge),
                          const SizedBox(height: 64),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
