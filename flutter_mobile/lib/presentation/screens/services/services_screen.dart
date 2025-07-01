import 'package:flutter/material.dart';

// Data model for box items from database
class BoxData {
  const BoxData({required this.title, required this.count});
  final String title;
  final String count;
}

// Main screen content widget
class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<BoxData> boxes = [
      const BoxData(title: 'Boite 1', count: '12'),
      const BoxData(title: 'Boite 2', count: '8'),
      const BoxData(title: 'Boite 3', count: '15'),
      const BoxData(title: 'Boite 1', count: '12'),
      const BoxData(title: 'Boite 2', count: '8'),
      const BoxData(title: 'Boite 3', count: '15'),
      const BoxData(title: 'Boite 1', count: '12'),
      const BoxData(title: 'Boite 2', count: '8'),
      const BoxData(title: 'Boite 3', count: '15'),
      const BoxData(title: 'Boite 1', count: '12'),
      const BoxData(title: 'Boite 2', count: '8'),
      const BoxData(title: 'Boite 3', count: '15'),
      const BoxData(title: 'Boite 1', count: '12'),
      const BoxData(title: 'Boite 2', count: '8'),
      const BoxData(title: 'Boite 3', count: '15'),

      // ... more from database
    ];
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          const SearchBarWidget(),
          const SizedBox(height: 24),

          // Grid of boxes
          Expanded(child: BoxGridWidget(boxes: boxes)),
        ],
      ),
    );
  }
}

// Search bar widget
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Votre recherche ici',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }
}

// Grid widget for boxes
class BoxGridWidget extends StatelessWidget {

  const BoxGridWidget({super.key, required this.boxes});
  final List<BoxData> boxes;

  // Predefined UI styles that cycle through the boxes
  static const List<Color> _colors = [
    Color(0xFF5FBEAA), // Teal
    Color(0xFFE8B4CB), // Pink
    Color(0xFF8FA7FF), // Blue
    Color(0xFFE5D5A3), // Beige
  ];

  static const List<IconData> _icons = [
    Icons.folder_outlined,
    Icons.favorite_outline,
    Icons.folder_outlined,
    Icons.favorite_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: boxes.length,
      itemBuilder: (context, index) {
        final box = boxes[index];
        // Use modulo to cycle through predefined styles - works for any number of items
        final styleIndex = index % _colors.length;

        return BoxCardWidget(
          color: _colors[styleIndex],
          icon: _icons[styleIndex],
          title: box.title,
          count: box.count,
        );
      },
    );
  }
}

// Individual box card widget
class BoxCardWidget extends StatelessWidget {

  const BoxCardWidget({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.count,
  });
  final Color color;
  final IconData icon;
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row with icon and arrow
            BoxCardHeaderWidget(icon: icon),

            const Spacer(),

            // Bottom content
            BoxCardContentWidget(title: title, count: count),
          ],
        ),
      ),
    );
  }
}

// Box card header (icon and arrow)
class BoxCardHeaderWidget extends StatelessWidget {

  const BoxCardHeaderWidget({super.key, required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
      ],
    );
  }
}

// Box card content (title and count)
class BoxCardContentWidget extends StatelessWidget {

  const BoxCardContentWidget({
    super.key,
    required this.title,
    required this.count,
  });
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
