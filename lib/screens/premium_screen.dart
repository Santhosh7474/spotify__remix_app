import 'package:flutter/material.dart';

class PremiumFeature {
  final IconData icon;
  final String title;
  final String desc;

  PremiumFeature(this.icon, this.title, this.desc);
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      PremiumFeature(
        Icons.music_off,
        "Ad-Free Music",
        "Enjoy uninterrupted songs with no ads.",
      ),
      PremiumFeature(
        Icons.download,
        "Offline Playback",
        "Download songs and listen offline.",
      ),
      PremiumFeature(
        Icons.high_quality,
        "High Quality Audio",
        "Studio-level sound experience.",
      ),
      PremiumFeature(
        Icons.skip_next,
        "Unlimited Skips",
        "Skip any track anytime.",
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Go Premium"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              "Experience the best of Spotify Remix",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 30),

            // Feature list
            Expanded(
              child: ListView.separated(
                itemCount: features.length,
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.white24),
                itemBuilder: (_, i) {
                  final f = features[i];
                  return ListTile(
                    leading: Icon(f.icon, color: Colors.green, size: 30),
                    title: Text(
                      f.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      f.desc,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                },
              ),
            ),

            // Subscribe button
            ElevatedButton(
              onPressed: () {
                // Implement premium subscription logic or mock it
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Redirecting to payment...")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 40,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Upgrade to Premium",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
