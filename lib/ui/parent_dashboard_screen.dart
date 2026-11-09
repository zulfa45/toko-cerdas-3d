import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_controller.dart';

class ParentDashboardScreen extends ConsumerStatefulWidget {
  const ParentDashboardScreen({super.key});

  @override
  ConsumerState<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends ConsumerState<ParentDashboardScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: ref.read(gameControllerProvider).shopName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFD7EDF7),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 760,
            height: 520,
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF16A085), width: 3),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 24, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F8F5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.family_restroom, color: Color(0xFF16A085), size: 28),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dasbor Orang Tua & Guru',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
                        ),
                        Text(
                          'Pantau perkembangan belajar matematika dan pengaturan toko anak',
                          style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D)),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ref.read(gameControllerProvider.notifier).goToScreen(GameScreen.home);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Main Dashboard Content
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left: Learning Progress & Pedagogy Report (PRD Bab 4)
                      Expanded(
                        flex: 6,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF9F5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE2D9CC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Perkembangan Kemampuan Matematika:',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF2C3E50)),
                              ),
                              const SizedBox(height: 10),

                              _buildSkillMetricRow(
                                skill: 'Penjumlahan Harga Ribuan',
                                status: 'Menguasai',
                                color: const Color(0xFF27AE60),
                              ),
                              _buildSkillMetricRow(
                                skill: 'Mengenal Pecahan Uang Rupiah',
                                status: 'Sangat Baik',
                                color: const Color(0xFF27AE60),
                              ),
                              _buildSkillMetricRow(
                                skill: 'Menyusun Uang Kembalian Pas',
                                status: state.currentDay >= 3 ? 'Menguasai' : 'Sedang Dilatih',
                                color: state.currentDay >= 3 ? const Color(0xFF27AE60) : const Color(0xFFF39C12),
                              ),
                              _buildSkillMetricRow(
                                skill: 'Perkalian Satuan (Jumlah × Harga)',
                                status: state.currentDay >= 4 ? 'Menguasai' : 'Level Lanjutan (Hari 4)',
                                color: state.currentDay >= 4 ? const Color(0xFF27AE60) : const Color(0xFF95A5A6),
                              ),

                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F8F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        const Text('Transaksi Sukses', style: TextStyle(fontSize: 11, color: Color(0xFF7F8C8D))),
                                        Text(
                                          '${state.totalCorrectTransactions} Kali',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF16A085)),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        const Text('Petunjuk Digunakan', style: TextStyle(fontSize: 11, color: Color(0xFF7F8C8D))),
                                        Text(
                                          '${state.totalHintsUsed} Kali',
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE67E22)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Right: Settings (Store Name, Audio, Reset)
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBF9F5),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: const Color(0xFFE2D9CC)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Pengaturan Toko:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 10),

                              // Store Name
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama Papan Toko',
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                ),
                                onSubmitted: (val) {
                                  if (val.trim().isNotEmpty) {
                                    ref.read(gameControllerProvider.notifier).setShopName(val.trim());
                                  }
                                },
                              ),
                              const SizedBox(height: 6),
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_nameController.text.trim().isNotEmpty) {
                                      ref.read(gameControllerProvider.notifier).setShopName(_nameController.text.trim());
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Nama toko diperbarui!')),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF16A085),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  ),
                                  child: const Text('Simpan Nama', style: TextStyle(fontSize: 12)),
                                ),
                              ),
                              const Divider(height: 16),

                              // Audio Toggle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Efek Suara Game:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                  Switch(
                                    value: state.isAudioEnabled,
                                    onChanged: (_) {
                                      ref.read(gameControllerProvider.notifier).toggleAudio();
                                    },
                                    activeColor: const Color(0xFF16A085),
                                  ),
                                ],
                              ),

                              const Spacer(),
                              // Reset Progress (2-Step Confirmation)
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: () => _showResetConfirmation(context, ref),
                                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                                  label: const Text('Reset Progres Permainan', style: TextStyle(color: Colors.red, fontSize: 12)),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillMetricRow({
    required String skill,
    required String status,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              skill,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2C3E50)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              status,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: color),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Reset'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus semua progres permainan, koin, dan bintang? Tindakan ini tidak dapat dibatalkan.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(ctx);
                await ref.read(gameControllerProvider.notifier).resetAllGameData();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Progres permainan berhasil di-reset.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Ya, Reset Semua'),
            ),
          ],
        );
      },
    );
  }
}
