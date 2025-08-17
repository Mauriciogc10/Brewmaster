import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../models/brew_method.dart';
import 'recipe_config_screen.dart';
import 'timer_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeBody(),
      const TimerScreen(),
      const HistoryScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
          NavigationDestination(icon: Icon(Icons.timer_outlined), selectedIcon: Icon(Icons.timer), label: 'Timer'),
          NavigationDestination(icon: Icon(Icons.history), selectedIcon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Ajustes'),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BrewMaster'),
        centerTitle: false,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: (){},
        child: const Icon(Icons.search),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          // Recently used horizontal list
          if (app.recentlyUsed.isNotEmpty) ...[
            const Text('Usados Recientemente', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: app.recentlyUsed.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final m = app.recentlyUsed[i];
                  return _RecentItem(method: m, onTap: () {
                    app.selectMethod(m);
                    Navigator.pushNamed(context, RecipeConfigScreen.routeName);
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Text('Métodos de Preparación', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...app.methods.map((m) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _MethodCard(method: m),
          )),
        ],
      ),
    );
  }
}

class _RecentItem extends StatelessWidget {
  final BrewMethod method;
  final VoidCallback onTap;
  const _RecentItem({required this.method, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(method.imageAsset, width: 80, height: 56, fit: BoxFit.cover),
          ),
          const SizedBox(height: 6),
          SizedBox(width: 80, child: Text(method.name, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center)),
        ],
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final BrewMethod method;
  const _MethodCard({required this.method});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final fav = app.isFavorite(method.id);
    final timeRange = method.timeRangeText;

    return InkWell(
      onTap: () {
        app.selectMethod(method);
        Navigator.pushNamed(context, RecipeConfigScreen.routeName);
      },
      child: Card(
        color: const Color(0xFFFFF8F0),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(method.imageAsset, width: 110, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(method.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))),
                        IconButton(
                          icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
                          color: fav ? Colors.redAccent : null,
                          onPressed: () => app.toggleFavorite(method.id),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.orange.shade700),
                        const SizedBox(width: 4),
                        Text(method.difficulty, style: TextStyle(color: Colors.orange.shade700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        const SizedBox(width: 6),
                        Text(timeRange),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.coffee_maker, size: 16),
                        const SizedBox(width: 6),
                        Expanded(child: Text(method.equipmentSummary, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}