import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/widgets/responsive_container.dart';
import '../../shared/widgets/section_title.dart';
import '../blog/data/blog_repository.dart';
import '../blog/models/blog_post_model.dart';

final blogRepositoryProvider =
    Provider<BlogRepository>((ref) => BlogRepository());
final publishedPostsProvider = FutureProvider<List<BlogPostModel>>((ref) async {
  return ref.read(blogRepositoryProvider).fetchPublishedPosts();
});

class BlogListPage extends ConsumerWidget {
  const BlogListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(publishedPostsProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            color: AppColors.secondary,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
            child: const SectionTitle(
              title: 'Bakery Journal',
              subtitle:
                  'Stories, recipes, and sweet inspirations from our kitchen.',
            ),
          ),
          const SizedBox(height: 48),
          ResponsiveContainer(
            child: postsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(80),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(80),
                  child: Text('Could not load posts.',
                      style: AppTypography.bodyLarge),
                ),
              ),
              data: (posts) => posts.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(80),
                        child: Text('No blog posts yet.',
                            style: AppTypography.bodyLarge),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 360,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: posts.length,
                      itemBuilder: (_, i) => _BlogCard(post: posts[i]),
                    ),
            ),
          ),
          const SizedBox(height: 64),
          const Footer(),
        ],
      ),
    );
  }
}

class _BlogCard extends StatefulWidget {
  final BlogPostModel post;
  const _BlogCard({required this.post});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.push('/blog/${widget.post.slug}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          transform: Matrix4.identity()
            ..translate(0.0, _hovered ? -4.0 : 0.0, 0.0),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _hovered ? 20 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: widget.post.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: widget.post.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                              color: AppColors.secondary,
                              child: const Icon(Icons.article,
                                  color: AppColors.primary, size: 40)),
                        )
                      : Container(
                          color: AppColors.secondary,
                          child: const Icon(Icons.article,
                              color: AppColors.primary, size: 40)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Formatters.formatDate(widget.post.createdAt),
                        style: AppTypography.caption),
                    const SizedBox(height: 8),
                    Text(widget.post.title,
                        style: AppTypography.headlineSmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    if (widget.post.content != null) ...[
                      const SizedBox(height: 8),
                      Text(widget.post.content!,
                          style: AppTypography.bodySmall,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis),
                    ],
                    const SizedBox(height: 12),
                    Text('Read more →',
                        style: AppTypography.labelMedium
                            .copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05);
  }
}
