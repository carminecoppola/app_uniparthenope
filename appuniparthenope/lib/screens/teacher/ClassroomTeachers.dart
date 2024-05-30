import 'package:flutter/material.dart';
import '../../widget/CustomLoadingIndicator.dart';
import '../../widget/ServicesWidget/RoomWidget/areaDropdown.dart';
import '../../widget/ServicesWidget/RoomWidget/roomList.dart';
import '../../widget/bottomNavBarProf.dart';
import '../../widget/navbar.dart';
import 'package:appuniparthenope/model/teacherService/room_data.dart';
import '../../main.dart';
import '../../utilityFunctions/studentUtilsFunction.dart';

class ClassroomTeacherPage extends StatefulWidget {
  const ClassroomTeacherPage({super.key});

  @override
  State<ClassroomTeacherPage> createState() => _ClassroomTeacherPageState();
}

class _ClassroomTeacherPageState extends State<ClassroomTeacherPage> {
  String _selectedArea = '...seleziona Ateneo...';
  List<AllTodayRooms>? _allRooms = [];
  List<AllTodayRooms>? _filteredRooms = [];
  bool _isLoading = true;
  bool _isFilterSelected = false;

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NavbarComponent(),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                height: 50,
                width: 250,
                color: AppColors.backgroundColor,
                child: AreaDropdown(
                  selectedArea: _selectedArea,
                  onChanged: _onAreaChanged,
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: _isLoading
                    ? const CustomLoadingIndicator(
                        text: 'Caricamento informazioni aule',
                        myColor: AppColors.primaryColor,
                      )
                    : _isFilterSelected
                        ? RoomsList(
                            rooms: _filteredRooms!,
                            selectedArea: _selectedArea,
                          )
                        : const Padding(
                            padding: EdgeInsets.all(25.0),
                            child: Text(
                              'Scegli un ateneo per visualizzare le aule.',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBarProfComponent(),
    );
  }

  void _loadRooms() async {
    try {
      final rooms = await StudentUtils.allRooms(context);
      setState(() {
        _allRooms = rooms ?? [];
        _filteredRooms = rooms ?? [];
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Handle error here, for example, show a Snackbar or an AlertDialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante il caricamento delle aule: $error'),
        ),
      );
    }
  }

  void _onAreaChanged(String? newValue) {
    setState(() {
      _selectedArea = newValue!;
      _isFilterSelected = true;
      _filterRooms();
    });
  }

  void _filterRooms() {
    if (_allRooms == null) return;

    setState(() {
      _filteredRooms = _allRooms!.where((room) {
        final areaMatch = room.area == _selectedArea ||
            _selectedArea == '...seleziona Ateneo...';

        return areaMatch;
      }).toList();
    });
  }
}
