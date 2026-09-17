import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const RollexStoreApp());
}

// -------------------------------------------------------------
// الألوان الرسمية لتطبيق رولكس استور
// -------------------------------------------------------------
class RollexColors {
  static const Color background = Color(0xFF090C19);       // كحلي ليلي فاحم
  static const Color surface = Color(0xFF12172B);          // كحلي للبطاقات
  static const Color surfaceLight = Color(0xFF1A213D);     // طبقة العناصر
  static const Color primaryBlue = Color(0xFF3865F6);      // أزرق الشعار
  static const Color neonCyan = Color(0xFF00D2FF);        // تدرج أزرق سماوي
  static const Color borderGlow = Color(0xFF242E52);       // حواف البطاقات
  static const Color textMuted = Color(0xFF8E9BB5);        // نصوص فرعية
}

// -------------------------------------------------------------
// النماذج (Models)
// -------------------------------------------------------------
class PackageItem {
  final String id;
  final String title;
  final double price;

  PackageItem({required this.id, required this.title, required this.price});
}

class GameItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String idPlaceholder;
  final List<PackageItem> packages;

  GameItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.idPlaceholder,
    required this.packages,
  });
}

class WalletTransaction {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isDeposit;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isDeposit,
  });
}

// -------------------------------------------------------------
// إدارة الحالة (State Management)
// -------------------------------------------------------------
class AppState extends ChangeNotifier {
  static final AppState instance = AppState._();
  AppState._();

  double walletBalance = 50000.0;

  final List<WalletTransaction> transactions = [
    WalletTransaction(
      id: "RLX-101",
      title: "شحن عبر بنكك",
      amount: 50000,
      date: DateTime.now().subtract(const Duration(hours: 2)),
      isDeposit: true,
    ),
  ];

  bool deductBalance(double amount, String itemName) {
    if (walletBalance >= amount) {
      walletBalance -= amount;
      transactions.insert(
        0,
        WalletTransaction(
          id: "RLX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
          title: "شراء $itemName",
          amount: amount,
          date: DateTime.now(),
          isDeposit: false,
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void addBalance(double amount, String method) {
    walletBalance += amount;
    transactions.insert(
      0,
      WalletTransaction(
        id: "RLX-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}",
        title: "إيداع عبر $method",
        amount: amount,
        date: DateTime.now(),
        isDeposit: true,
      ),
    );
    notifyListeners();
  }
}

// -------------------------------------------------------------
// شعار رولكس استور المفرغ بدون خلفية
// -------------------------------------------------------------
class RollexLogoWidget extends StatelessWidget {
  final double size;
  final bool showText;

  const RollexLogoWidget({super.key, this.size = 50, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: Size(size, size * 0.55),
          painter: _RollexInfinityPainter(),
        ),
        if (showText) ...[
          const SizedBox(height: 6),
          Text(
            "ROLLEX STORE",
            style: GoogleFonts.rajdhani(
              fontSize: size * 0.28,
              fontWeight: FontWeight.w800,
              letterSpacing: 3.5,
              color: Colors.white,
            ),
          ),
          Text(
            "لشحن وبيع بطاقات الألعاب الإلكترونية",
            style: GoogleFonts.cairo(
              fontSize: size * 0.14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ],
    );
  }
}

class _RollexInfinityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.height * 0.18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final path = Path();
    path.moveTo(w * 0.22, h * 0.85);
    path.lineTo(w * 0.08, h * 0.5);
    path.lineTo(w * 0.35, h * 0.12);
    path.lineTo(w * 0.65, h * 0.88);
    path.lineTo(w * 0.92, h * 0.5);
    path.lineTo(w * 0.78, h * 0.15);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------------------------------------------------
// التطبيق الرئيسي
// -------------------------------------------------------------
class RollexStoreApp extends StatelessWidget {
  const RollexStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رولكس استور',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SD'),
      supportedLocales: const [Locale('ar', 'SD'), Locale('en', '')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: RollexColors.background,
        primaryColor: RollexColors.primaryBlue,
        colorScheme: const ColorScheme.dark(
          primary: RollexColors.primaryBlue,
          secondary: RollexColors.neonCyan,
          surface: RollexColors.surface,
        ),
        textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// -------------------------------------------------------------
// شريط التنقل
// -------------------------------------------------------------
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    WalletScreen(),
    OrdersHistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: RollexColors.borderGlow, width: 0.8)),
        ),
        child: NavigationBar(
          backgroundColor: RollexColors.surface,
          indicatorColor: RollexColors.primaryBlue.withValues(alpha: 0.25),
          selectedIndex: _currentIndex,
          onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.sports_esports_outlined), selectedIcon: Icon(Icons.sports_esports, color: RollexColors.neonCyan), label: 'المتجر'),
            NavigationDestination(icon: Icon(Icons.account_balance_wallet_outlined), selectedIcon: Icon(Icons.account_balance_wallet, color: RollexColors.neonCyan), label: 'المحفظة'),
            NavigationDestination(icon: Icon(Icons.receipt_long_outlined), selectedIcon: Icon(Icons.receipt_long, color: RollexColors.neonCyan), label: 'طلباتي'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: RollexColors.neonCyan), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// الشاشة الرئيسية (Home)
// -------------------------------------------------------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = "الكل";

  final List<String> categories = ["الكل", "ألعاب موبايل", "بطاقات رقمية", "اشتراكات"];

  final List<GameItem> games = [
    GameItem(
      id: "pubg",
      name: "ببجي موبايل (PUBG)",
      category: "ألعاب موبايل",
      imageUrl: "https://images.unsplash.com/photo-1542751371-adc38448a05e?q=80&w=500&auto=format&fit=crop",
      idPlaceholder: "أدخل معرف اللاعب (Player ID)",
      packages: [
        PackageItem(id: "p1", title: "60 شدة UC", price: 1250),
        PackageItem(id: "p2", title: "325 شدة UC", price: 6200),
        PackageItem(id: "p3", title: "660 شدة UC", price: 12200),
        PackageItem(id: "p4", title: "1800 شدة UC", price: 31000),
      ],
    ),
    GameItem(
      id: "freefire",
      name: "فري فاير (Free Fire)",
      category: "ألعاب موبايل",
      imageUrl: "https://images.unsplash.com/photo-1538481199705-c710c4e965fc?q=80&w=500&auto=format&fit=crop",
      idPlaceholder: "أدخل معرف الحساب (UID)",
      packages: [
        PackageItem(id: "f1", title: "110 جوهرة", price: 1150),
        PackageItem(id: "f2", title: "231 جوهرة", price: 2300),
        PackageItem(id: "f3", title: "583 جوهرة", price: 5600),
      ],
    ),
    GameItem(
      id: "jawaker",
      name: "جواكر (Jawaker)",
      category: "ألعاب موبايل",
      imageUrl: "https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=500&auto=format&fit=crop",
      idPlaceholder: "أدخل رقم حساب جواكر",
      packages: [
        PackageItem(id: "j1", title: "50,000 توكنز", price: 2600),
        PackageItem(id: "j2", title: "120,000 توكنز", price: 6100),
      ],
    ),
    GameItem(
      id: "razer",
      name: "بطاقات ريزر جولد",
      category: "بطاقات رقمية",
      imageUrl: "https://images.unsplash.com/photo-1612287233207-6b2158866164?q=80&w=500&auto=format&fit=crop",
      idPlaceholder: "سيصل الكود مباشرة لحسابك",
      packages: [
        PackageItem(id: "r1", title: "بطاقة 5\$ دولار", price: 14500),
        PackageItem(id: "r2", title: "بطاقة 10\$ دولار", price: 28800),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredGames = _selectedCategory == "الكل"
        ? games
        : games.where((g) => g.category == _selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: RollexColors.surface,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: const RollexLogoWidget(size: 38, showText: true),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E284A), RollexColors.background],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: AppState.instance,
              builder: (context, _) {
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E2749), Color(0xFF11172E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: RollexColors.borderGlow),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("رصيد محفظة رولكس", style: TextStyle(color: RollexColors.textMuted, fontSize: 13)),
                          const SizedBox(height: 4),
                          Text(
                            "${AppState.instance.walletBalance.toStringAsFixed(0)} ج.س",
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: RollexColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _showTopUpSheet(context),
                        icon: const Icon(Icons.add_card, size: 18),
                        label: const Text("شحن المحفظة"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: RollexColors.primaryBlue,
                    backgroundColor: RollexColors.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : RollexColors.textMuted,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    side: BorderSide(
                      color: isSelected ? RollexColors.neonCyan : RollexColors.borderGlow,
                    ),
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                  );
                },
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final game = filteredGames[index];
                  return _GameItemCard(game: game);
                },
                childCount: filteredGames.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// بطاقة اللعبة
// -------------------------------------------------------------
class _GameItemCard extends StatelessWidget {
  final GameItem game;
  const _GameItemCard({required this.game});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GameDetailScreen(game: game)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: RollexColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: RollexColors.borderGlow),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.network(
                  game.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: RollexColors.surfaceLight,
                    child: const Icon(Icons.sports_esports, color: RollexColors.textMuted),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "تبدأ من ${game.packages.first.price.toStringAsFixed(0)} ج.س",
                    style: const TextStyle(color: RollexColors.neonCyan, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// تفاصيل اللعبة والشحن
// -------------------------------------------------------------
class GameDetailScreen extends StatefulWidget {
  final GameItem game;
  const GameDetailScreen({super.key, required this.game});

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  final TextEditingController _idController = TextEditingController();
  PackageItem? _selectedPackage;

  @override
  void initState() {
    super.initState();
    _selectedPackage = widget.game.packages.first;
  }

  void _confirmPurchase() {
    if (_idController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال رقم المعرف (ID) الخاص بالحساب"), backgroundColor: Colors.redAccent),
      );
      return;
    }

    final success = AppState.instance.deductBalance(
      _selectedPackage!.price,
      "${widget.game.name} (${_selectedPackage!.title})",
    );

    if (success) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: RollexColors.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.greenAccent),
              SizedBox(width: 8),
              Text("تم إرسال الطلب بنجاح"),
            ],
          ),
          content: Text("تم خصم ${_selectedPackage!.price} ج.س بنجاح. جاري شحن الحساب (${_idController.text}) عبر رولكس استور."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text("تم", style: TextStyle(color: RollexColors.neonCyan)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("رصيدك غير كافٍ. يرجى شحن محفظتك للمتابعة"),
          backgroundColor: Colors.orangeAccent,
          action: SnackBarAction(
            label: "شحن الآن",
            textColor: Colors.white,
            onPressed: () => _showTopUpSheet(context),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        backgroundColor: RollexColors.surface,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("بيانات الحساب / المعرف", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          TextField(
            controller: _idController,
            decoration: InputDecoration(
              hintText: widget.game.idPlaceholder,
              prefixIcon: const Icon(Icons.tag, color: RollexColors.neonCyan),
              filled: true,
              fillColor: RollexColors.surface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RollexColors.borderGlow)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: RollexColors.borderGlow)),
            ),
          ),
          const SizedBox(height: 24),
          const Text("اختر باقة الشحن", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          ...widget.game.packages.map((pkg) {
            final isSelected = _selectedPackage?.id == pkg.id;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: RollexColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? RollexColors.neonCyan : RollexColors.borderGlow,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: ListTile(
                onTap: () => setState(() => _selectedPackage = pkg),
                leading: Icon(Icons.flash_on, color: isSelected ? RollexColors.neonCyan : RollexColors.textMuted),
                title: Text(pkg.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(
                  "${pkg.price.toStringAsFixed(0)} ج.س",
                  style: const TextStyle(color: RollexColors.neonCyan, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: RollexColors.surface,
          border: Border(top: BorderSide(color: RollexColors.borderGlow)),
        ),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: RollexColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _confirmPurchase,
            child: Text("تأكيد ودفع ${_selectedPackage?.price.toStringAsFixed(0) ?? 0} ج.س"),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// شاشة المحفظة
// -------------------------------------------------------------
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("محفظة رولكس"), backgroundColor: RollexColors.surface),
      body: AnimatedBuilder(
        animation: AppState.instance,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF222C54), Color(0xFF0F1426)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: RollexColors.borderGlow),
                ),
                child: Column(
                  children: [
                    const Text("الرصيد المتاح للاستخدام", style: TextStyle(color: RollexColors.textMuted, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(
                      "${AppState.instance.walletBalance.toStringAsFixed(0)} ج.س",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: RollexColors.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _showTopUpSheet(context),
                      icon: const Icon(Icons.upload_file),
                      label: const Text("إيداع رصيد (إشعار بنكك)"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text("سجل المعاملات", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ...AppState.instance.transactions.map((tx) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: RollexColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: RollexColors.borderGlow),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: tx.isDeposit ? Colors.green.withValues(alpha: 0.15) : Colors.red.withValues(alpha: 0.15),
                      child: Icon(
                        tx.isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                        color: tx.isDeposit ? Colors.greenAccent : Colors.redAccent,
                      ),
                    ),
                    title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text("${tx.date.hour}:${tx.date.minute} - ${tx.date.day}/${tx.date.month}/${tx.date.year}", style: const TextStyle(color: RollexColors.textMuted, fontSize: 12)),
                    trailing: Text(
                      "${tx.isDeposit ? '+' : '-'}${tx.amount.toStringAsFixed(0)} ج.س",
                      style: TextStyle(color: tx.isDeposit ? Colors.greenAccent : Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// سجل الطلبات
// -------------------------------------------------------------
class OrdersHistoryScreen extends StatelessWidget {
  const OrdersHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = AppState.instance.transactions.where((t) => !t.isDeposit).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("سجل الطلبات"), backgroundColor: RollexColors.surface),
      body: orders.isEmpty
          ? const Center(child: Text("لا توجد طلبات سابقة حتى الآن", style: TextStyle(color: RollexColors.textMuted)))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final o = orders[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: RollexColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: RollexColors.borderGlow),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text("رقم العملية: ${o.id}", style: const TextStyle(color: RollexColors.textMuted, fontSize: 12)),
                        ],
                      ),
                      const Chip(
                        label: Text("مكتمل", style: TextStyle(fontSize: 11, color: Colors.greenAccent)),
                        backgroundColor: Color(0xFF142B23),
                        side: BorderSide.none,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// -------------------------------------------------------------
// الملف الشخصي
// -------------------------------------------------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حسابي"), backgroundColor: RollexColors.surface),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: RollexLogoWidget(size: 65, showText: true),
          ),
          const SizedBox(height: 24),
          _item(Icons.headset_mic_outlined, "الدعم الفني المباشر"),
          _item(Icons.lock_outline, "الأمان وتغيير كلمة السر"),
          _item(Icons.privacy_tip_outlined, "سياسة الخصوصية والشروط"),
          _item(Icons.logout, "تسجيل الخروج", isDestructive: true),
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: RollexColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: RollexColors.borderGlow),
      ),
      child: ListTile(
        leading: Icon(icon, color: isDestructive ? Colors.redAccent : RollexColors.neonCyan),
        title: Text(title, style: TextStyle(color: isDestructive ? Colors.redAccent : Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: RollexColors.textMuted),
        onTap: () {},
      ),
    );
  }
}

// -------------------------------------------------------------
// نافذة شحن الرصيد
// -------------------------------------------------------------
void _showTopUpSheet(BuildContext context) {
  final amountController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: RollexColors.surface,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("شحن المحفظة عبر بنكك", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: RollexColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: RollexColors.borderGlow),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("رقم الحساب: 2580147 (بنك الخرطوم)", style: TextStyle(fontWeight: FontWeight.bold, color: RollexColors.neonCyan)),
                  Text("الاسم: رولكس ستور للخدمات الرقمية", style: TextStyle(color: RollexColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "أدخل المبلغ المحول (ج.س)",
                filled: true,
                fillColor: RollexColors.background,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: RollexColors.borderGlow)),
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: RollexColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final amount = double.tryParse(amountController.text);
                if (amount != null && amount > 0) {
                  AppState.instance.addBalance(amount, "بنكك");
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("تمت إضافة $amount ج.س إلى محفظتك بنجاح!"), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text("تأكيد طلب الشحن"),
            ),
          ],
        ),
      );
    },
  );
}
