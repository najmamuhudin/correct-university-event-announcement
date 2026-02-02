import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';
import 'event_details_screen.dart';
import 'profile_screen.dart';
import 'package:provider/provider.dart';
import '../providers/navigation_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/event_provider.dart';
import '../providers/admin_provider.dart';
import '../utils/constants.dart';
import '../utils/image_helper.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
      Provider.of<AdminProvider>(context, listen: false).fetchAnnouncements();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    final userName = user?['name'] ?? 'Student';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<EventProvider>(
              context,
              listen: false,
            ).fetchEvents();
            await Provider.of<AdminProvider>(
              context,
              listen: false,
            ).fetchAnnouncements();
          },
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer<NavigationProvider>(
                        builder: (context, navProvider, _) => GestureDetector(
                          onTap: () {
                            if (navProvider.isDrawerOpen) {
                              navProvider.setIndex(0);
                            }
                            ZoomDrawer.of(context)?.toggle();
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.all(
                              navProvider.isDrawerOpen ? 8 : 4,
                            ),
                            decoration: BoxDecoration(
                              color: navProvider.isDrawerOpen
                                  ? Colors.white
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              boxShadow: navProvider.isDrawerOpen
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Icon(
                              navProvider.isDrawerOpen
                                  ? Icons.close
                                  : Icons.menu,
                              size: navProvider.isDrawerOpen ? 24 : 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              user?['profileImage'] ??
                                  'https://i.pravatar.cc/150?u=student',
                            ),
                            child: (user?['profileImage'] == null)
                                ? const Icon(Icons.person)
                                : null,
                            radius: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Featured Events Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Events',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<NavigationProvider>(
                            context,
                            listen: false,
                          ).setIndex(1);
                        },
                        child: Text(
                          'See all',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF3A4F9B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Horizontal Scrollable Events
                SizedBox(
                  height: 220,
                  child: Consumer<EventProvider>(
                    builder: (context, eventProvider, _) {
                      if (eventProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (eventProvider.events.isEmpty) {
                        return const Center(
                          child: Text(
                            "No upcoming events",
                            style: TextStyle(color: Colors.grey),
                          ),
                        );
                      }

                      // Take top 3 events as featured
                      final featured = eventProvider.events.take(3).toList();

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: featured.length,
                        itemBuilder: (context, index) {
                          final event = featured[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: _buildFeaturedEventCard(context, event),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Campus News Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Campus News',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Provider.of<NavigationProvider>(
                            context,
                            listen: false,
                          ).setIndex(2);
                        },
                        child: Text(
                          'View all',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: const Color(0xFF3A4F9B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // News List
                Consumer<AdminProvider>(
                  builder: (context, adminProvider, _) {
                    if (adminProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (adminProvider.announcements.isEmpty) {
                      return const Center(
                        child: Text(
                          "No campus news available",
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    // Take latest 3 as news
                    final news = adminProvider.announcements.take(3).toList();

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: news.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 24),
                      itemBuilder: (context, index) {
                        final a = news[index];
                        return _buildNewsItem(
                          category: (a['urgent'] == true) ? 'URGENT' : 'CAMPUS',
                          title: a['title'] ?? 'Untitled',
                          time: _formatTime(a['createdAt']),
                          description: a['message'] ?? '',
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return DateFormat('MMM d').format(date);
    } catch (e) {
      return '';
    }
  }

  Widget _buildFeaturedEventCard(BuildContext context, dynamic event) {
    final title = event['title'] ?? 'Untitled Event';
    final date = event['date'] ?? 'TBA';
    final location = event['location'] ?? 'Campus';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
        );
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[200],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image Layer
            ImageHelper.buildNetworkImage(
              event['imageUrl'],
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white70,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$date • $location',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem({
    required String category,
    required String title,
    required String time,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF3A4F9B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Color(0xFF3A4F9B),
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            Row(
              children: [
                Icon(Icons.share, size: 16, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  'Share',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
