import 'package:flutter/material.dart';

class Student {
	final String id;
	final String name;
	final String kelas;
	final bool layak; // eligible
	bool telahAmbil; // taken meal

	Student({
		required this.id,
		required this.name,
		required this.kelas,
		required this.layak,
		this.telahAmbil = false,
	});
}

class RmtScreen extends StatefulWidget {
	const RmtScreen({super.key});

	@override
	State<RmtScreen> createState() => _RmtScreenState();
}

class _RmtScreenState extends State<RmtScreen>
		with SingleTickerProviderStateMixin {
	late final TabController _tabController;
	final TextEditingController _searchController = TextEditingController();

	// Sample students (mocked). In a real app this would come from a service.
	final List<Student> _students = [
		Student(id: 'S001', name: 'Aminah Binti Ahmad', kelas: '1A', layak: true),
		Student(id: 'S002', name: 'Muhammad Faiz', kelas: '1A', layak: true, telahAmbil: true),
		Student(id: 'S003', name: 'Nurul Izzah', kelas: '1B', layak: false),
		Student(id: 'S004', name: 'Ahmad Zaki', kelas: '2A', layak: true),
		Student(id: 'S005', name: 'Siti Mariam', kelas: '2B', layak: true, telahAmbil: true),
	];

	// Menu sample for week (1 = Monday ... 5 = Friday)
	final Map<int, Map<String, String>> _weeklyMenu = {
		1: {
			'hidangan': 'Nasi Putih',
			'lauk': 'Ayam Masak Merah',
			'minuman': 'Air Sirap',
			'buah': 'Epal',
		},
		2: {
			'hidangan': 'Nasi Lemak',
			'lauk': 'Ikan Goreng',
			'minuman': 'Teh O',
			'buah': 'Pisang',
		},
		3: {
			'hidangan': 'Mee Goreng',
			'lauk': 'Telur Dadar',
			'minuman': 'Air Milo',
			'buah': 'Oren',
		},
		4: {
			'hidangan': 'Bihun Sup',
			'lauk': 'Daging Masak Kicap',
			'minuman': 'Air Limau',
			'buah': 'Betik',
		},
		5: {
			'hidangan': 'Nasi Goreng',
			'lauk': 'Sotong Goreng',
			'minuman': 'Air Bandung',
			'buah': 'Anggur',
		},
	};

	int _selectedWeekdayIndex = DateTime.now().weekday;

	@override
	void initState() {
		super.initState();
		_tabController = TabController(length: 2, vsync: this);
		// ensure selected weekday is within 1..5 (Mon-Fri); default to Monday if weekend
		if (_selectedWeekdayIndex < 1 || _selectedWeekdayIndex > 5) {
			_selectedWeekdayIndex = 1;
		}
	}

	@override
	void dispose() {
		_tabController.dispose();
		_searchController.dispose();
		super.dispose();
	}

	List<Student> get _filteredStudents {
		final q = _searchController.text.toLowerCase().trim();
		if (q.isEmpty) return _students;
		return _students.where((s) {
			return s.name.toLowerCase().contains(q) || s.kelas.toLowerCase().contains(q) || s.id.toLowerCase().contains(q);
		}).toList();
	}

	int get _totalLayak => _students.where((s) => s.layak).length;
	int get _telahAmbil => _students.where((s) => s.telahAmbil).length;

	String _namaHari(int weekday) {
		switch (weekday) {
			case DateTime.monday:
				return 'Isnin';
			case DateTime.tuesday:
				return 'Selasa';
			case DateTime.wednesday:
				return 'Rabu';
			case DateTime.thursday:
				return 'Khamis';
			case DateTime.friday:
				return 'Jumaat';
			case DateTime.saturday:
				return 'Sabtu';
			case DateTime.sunday:
				return 'Ahad';
			default:
				return '';
		}
	}

	void _onScanQr() {
		Navigator.pushNamed(context, '/qr_scanner');
	}

	@override
	Widget build(BuildContext context) {
		final today = DateTime.now();
		final todayMenu = _weeklyMenu[_selectedWeekdayIndex] ?? _weeklyMenu[1]!;

		return Scaffold(
			appBar: AppBar(
				title: const Text('RMT — Rancangan Makanan Tambahan'),
				bottom: TabBar(
					controller: _tabController,
					tabs: const [
						Tab(text: 'Kehadiran'),
						Tab(text: 'Menu Hari Ini'),
					],
				),
				actions: [
					IconButton(
						tooltip: 'Imbas Kod QR',
						icon: const Icon(Icons.qr_code_scanner),
						onPressed: _onScanQr,
					),
				],
			),
			body: TabBarView(
				controller: _tabController,
				children: [
					// Kehadiran tab
					Padding(
						padding: const EdgeInsets.all(12.0),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Card(
									elevation: 2,
									child: Padding(
										padding: const EdgeInsets.all(12.0),
										child: Row(
											mainAxisAlignment: MainAxisAlignment.spaceAround,
											children: [
												Column(
													children: [
														const Text('Telah Ambil', style: TextStyle(fontWeight: FontWeight.bold)),
														const SizedBox(height: 6),
														Text('$_telahAmbil', style: const TextStyle(fontSize: 18, color: Colors.green)),
													],
												),
												Column(
													children: [
														const Text('Layak', style: TextStyle(fontWeight: FontWeight.bold)),
														const SizedBox(height: 6),
														Text('$_totalLayak', style: const TextStyle(fontSize: 18)),
													],
												),
												Column(
													children: [
														const Text('Belum Ambil', style: TextStyle(fontWeight: FontWeight.bold)),
														const SizedBox(height: 6),
														Text('${_totalLayak - _telahAmbil}', style: const TextStyle(fontSize: 18, color: Colors.orange)),
													],
												),
											],
										),
									),
								),

								const SizedBox(height: 12),
								TextField(
									controller: _searchController,
									decoration: InputDecoration(
										prefixIcon: const Icon(Icons.search),
										hintText: 'Cari pelajar (nama, kelas atau ID)',
										border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
										suffixIcon: _searchController.text.isNotEmpty
												? IconButton(
														icon: const Icon(Icons.clear),
														onPressed: () {
															setState(() {
																_searchController.clear();
															});
														},
													)
												: null,
									),
									onChanged: (_) => setState(() {}),
								),

								const SizedBox(height: 12),
								Expanded(
									child: _filteredStudents.isEmpty
											? Center(child: Text('Tiada pelajar ditemui.', style: TextStyle(color: Colors.grey[700])))
											: ListView.separated(
													itemCount: _filteredStudents.length,
													  separatorBuilder: (context, index) => const Divider(height: 1),
													itemBuilder: (context, index) {
														final s = _filteredStudents[index];
														return ListTile(
															leading: CircleAvatar(
																child: Text(s.name.split(' ').map((p) => p.isNotEmpty ? p[0] : '').take(2).join()),
															),
															title: Text(s.name),
															subtitle: Text('Kelas: ${s.kelas} • ID: ${s.id}'),
															trailing: Column(
																mainAxisAlignment: MainAxisAlignment.center,
																children: [
																	Chip(
																		label: Text(s.telahAmbil ? 'Telah Ambil' : (s.layak ? 'Layak' : 'Tidak Layak')),
																		backgroundColor: s.telahAmbil
																				? Colors.green[100]
																				: (s.layak ? Colors.grey[200] : Colors.red[100]),
																	),
																	if (s.layak && !s.telahAmbil)
																		TextButton(
																			onPressed: () {
																				setState(() {
																					s.telahAmbil = true;
																				});
																			},
																			child: const Text('Tandakan Ambil'),
																		)
																],
															),
														);
													},
												),
								),
							],
						),
					),

					// Menu Hari Ini tab
					SingleChildScrollView(
						padding: const EdgeInsets.all(12),
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text('Tarikh: ${today.day}/${today.month}/${today.year}', style: const TextStyle(fontWeight: FontWeight.bold)),
								const SizedBox(height: 4),
								Text('Hari: ${_namaHari(_selectedWeekdayIndex)}'),
								const SizedBox(height: 12),

								Card(
									elevation: 2,
									child: Padding(
										padding: const EdgeInsets.all(12.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												const Text('Menu Hari Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
												const SizedBox(height: 8),
												_menuRow('Hidangan Utama', todayMenu['hidangan'] ?? '-'),
												_menuRow('Lauk Pauk', todayMenu['lauk'] ?? '-'),
												_menuRow('Minuman', todayMenu['minuman'] ?? '-'),
												_menuRow('Buah-buahan', todayMenu['buah'] ?? '-'),
											],
										),
									),
								),

								const SizedBox(height: 16),
								const Text('Menu Minggu Ini', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
								const SizedBox(height: 8),
								SizedBox(
									height: 52,
									child: ListView.builder(
										scrollDirection: Axis.horizontal,
										itemCount: 5,
										itemBuilder: (context, i) {
											final dayIndex = i + 1; // 1..5
											final dayName = _namaHari(dayIndex);
											final isSelected = dayIndex == _selectedWeekdayIndex;
											return Padding(
												padding: const EdgeInsets.only(right: 8),
												child: ChoiceChip(
													label: Text(dayName),
													selected: isSelected,
													onSelected: (_) {
														setState(() {
															_selectedWeekdayIndex = dayIndex;
														});
													},
												),
											);
										},
									),
								),

								const SizedBox(height: 12),
								Card(
									elevation: 1,
									child: Padding(
										padding: const EdgeInsets.all(12.0),
										child: Column(
											crossAxisAlignment: CrossAxisAlignment.start,
											children: [
												Text('${_namaHari(_selectedWeekdayIndex)} — Butiran Menu', style: const TextStyle(fontWeight: FontWeight.bold)),
												const SizedBox(height: 8),
												_menuRow('Hidangan Utama', (_weeklyMenu[_selectedWeekdayIndex]?['hidangan']) ?? '-'),
												_menuRow('Lauk Pauk', (_weeklyMenu[_selectedWeekdayIndex]?['lauk']) ?? '-'),
												_menuRow('Minuman', (_weeklyMenu[_selectedWeekdayIndex]?['minuman']) ?? '-'),
												_menuRow('Buah-buahan', (_weeklyMenu[_selectedWeekdayIndex]?['buah']) ?? '-'),
											],
										),
									),
								),
							],
						),
					),
				],
			),
			floatingActionButton: _tabController.index == 0
					? FloatingActionButton.extended(
							onPressed: _onScanQr,
							icon: const Icon(Icons.qr_code_scanner),
							label: const Text('Imbas Kod QR'),
						)
					: null,
		);
	}

	Widget _menuRow(String label, String value) {
		return Padding(
			padding: const EdgeInsets.symmetric(vertical: 6.0),
			child: Row(
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					SizedBox(width: 140, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
					Expanded(child: Text(value)),
				],
			),
		);
	}
}
