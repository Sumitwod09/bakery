class BlogPostModel {
  final String id;
  final String title;
  final String slug;
  final String? content;
  final String? imageUrl;
  final bool published;
  final DateTime createdAt;

  const BlogPostModel({
    required this.id,
    required this.title,
    required this.slug,
    this.content,
    this.imageUrl,
    required this.published,
    required this.createdAt,
  });

  factory BlogPostModel.fromJson(Map<String, dynamic> json) => BlogPostModel(
    id: json['id'] as String,
    title: json['title'] as String,
    slug: json['slug'] as String,
    content: json['content'] as String?,
    imageUrl: json['image_url'] as String?,
    published: json['published'] as bool? ?? false,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'slug': slug,
    'content': content,
    'image_url': imageUrl,
    'published': published,
  };
}
