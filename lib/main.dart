import 'package:flutter/material.dart';

void main() => runApp(const CvApp());

class CvApp extends StatelessWidget {
  const CvApp({super.key});

  @override
  Widget build(BuildContext context) {
    final uri = Uri.base;
    if (uri.queryParameters['demo'] == '1') {
      final page = int.tryParse(uri.queryParameters['page'] ?? '0') ?? 0;
      return MaterialApp(
        title: 'CV - Tshirezi Sarah',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
          scaffoldBackgroundColor: const Color(0xFFF7F5FB),
        ),
        home: MainPage(initialIndex: page.clamp(0, 2)),
      );
    }
    return MaterialApp(
      title: 'CV - Tshirezi Sarah',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
        scaffoldBackgroundColor: const Color(0xFFF7F5FB),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_loginController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Veuillez renseigner l’identifiant et le mot de passe.',
          ),
        ),
      );
      return;
    }
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE8DEF8), Color(0xFFF7F5FB)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircleAvatar(
                        radius: 42,
                        backgroundColor: Color(0xFF6750A4),
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Bienvenue',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Connectez-vous pour consulter le CV',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 28),
                      TextField(
                        controller: _loginController,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Identifiant',
                          prefixIcon: Icon(Icons.badge_outlined),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onSubmitted: (_) => _login(),
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: FilledButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.login),
                          label: const Text('Se connecter'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _index = 0;

  final _pages = const [CvPage(), FamilyPage(), ContactPage()];
  final _titles = const ['Mon CV', 'Ma famille', 'Contact'];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index]), centerTitle: true),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF6750A4)),
                accountName: Text('Tshirezi Lwaboshi Sarah'),
                accountEmail: Text('Étudiante en informatique'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300',
                  ),
                ),
              ),
              for (var i = 0; i < _titles.length; i++)
                ListTile(
                  leading: Icon(
                    [
                      Icons.description_outlined,
                      Icons.family_restroom,
                      Icons.contact_mail_outlined,
                    ][i],
                  ),
                  title: Text(_titles[i]),
                  selected: _index == i,
                  onTap: () {
                    setState(() => _index = i);
                    Navigator.pop(context);
                  },
                ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Se déconnecter'),
                onTap: () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'CV',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon: Icon(Icons.family_restroom),
            label: 'Famille',
          ),
          NavigationDestination(
            icon: Icon(Icons.contact_mail_outlined),
            selectedIcon: Icon(Icons.contact_mail),
            label: 'Contact',
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 22),
            child,
          ],
        ),
      ),
    );
  }
}

class CvPage extends StatelessWidget {
  const CvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 58,
                  backgroundImage: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tshirezi Lwaboshi Sarah',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Étudiante en informatique · Développeuse Flutter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Étudiante motivée, passionnée par le développement mobile, les interfaces modernes et les solutions numériques utiles.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SectionCard(
          title: 'Formation',
          icon: Icons.school_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Licence/Bachelor en Informatique',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('2023 – 2026 · Institut supérieur'),
              SizedBox(height: 8),
              Text(
                'Baccalauréat scientifique',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('2022 · Option sciences'),
            ],
          ),
        ),
        const SectionCard(
          title: 'Expériences',
          icon: Icons.work_outline,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stage en développement informatique',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '2025 · Réalisation d’une application mobile et participation aux tests.',
              ),
              SizedBox(height: 10),
              Text(
                'Projets académiques',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Applications Flutter, gestion de données et interfaces responsive.',
              ),
            ],
          ),
        ),
        const SectionCard(
          title: 'Compétences techniques',
          icon: Icons.code,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text('Flutter')),
              Chip(label: Text('Dart')),
              Chip(label: Text('Git')),
              Chip(label: Text('Firebase')),
              Chip(label: Text('HTML/CSS')),
              Chip(label: Text('SQL')),
            ],
          ),
        ),
        const SectionCard(
          title: 'Langues',
          icon: Icons.translate,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Français — Courant'),
              Text('Anglais — Intermédiaire'),
              Text('Swahili — Courant'),
            ],
          ),
        ),
        const SectionCard(
          title: 'Centres d’intérêt',
          icon: Icons.favorite_outline,
          child: Text(
            'Développement mobile • Lecture • Technologie • Design • Entrepreneuriat',
          ),
        ),
      ],
    );
  }
}

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final members = [
      (
        'Papa',
        'Parent',
        'Chef d’entreprise',
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=300',
      ),
      (
        'Maman',
        'Parent',
        'Professionnelle',
        'https://images.unsplash.com/photo-1551836022-d5d88e9218df?w=300',
      ),
      (
        'Frère',
        'Frère',
        'Étudiant',
        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300',
      ),
      (
        'Sœur',
        'Sœur',
        'Étudiante',
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300',
      ),
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).size.width > 700 ? 3 : 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.78,
      ),
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  member.$4,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      member.$1,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      member.$2,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(member.$3, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ContactTile(
          icon: Icons.phone_outlined,
          title: 'Téléphone',
          subtitle: '+243 900 000 000',
        ),
        ContactTile(
          icon: Icons.email_outlined,
          title: 'E-mail',
          subtitle: 'sarah@example.com',
        ),
        ContactTile(
          icon: Icons.location_on_outlined,
          title: 'Adresse',
          subtitle: 'Kinshasa, République démocratique du Congo',
        ),
        ContactTile(
          icon: Icons.link,
          title: 'LinkedIn',
          subtitle: 'linkedin.com/in/sarahlwaboshi',
        ),
        ContactTile(
          icon: Icons.code,
          title: 'GitHub',
          subtitle: 'github.com/sarahlb21',
        ),
        ContactTile(
          icon: Icons.camera_alt_outlined,
          title: 'Instagram',
          subtitle: '@sarah.tshirezi',
        ),
      ],
    );
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
