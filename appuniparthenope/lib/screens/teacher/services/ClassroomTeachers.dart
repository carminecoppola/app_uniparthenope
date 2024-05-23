import 'package:flutter/material.dart';
import 'package:appuniparthenope/model/teacherService/room_data.dart';
import '../../../main.dart';
import '../../../utilityFunctions/studentUtilsFunction.dart';
import '../../../widget/CustomLoadingIndicator.dart';
import '../../../widget/ServicesWidget/RoomWidget/areaDropdown.dart';
import '../../../widget/ServicesWidget/RoomWidget/roomList.dart'; // Importa la barra di ricerca
import '../../../widget/ServicesWidget/RoomWidget/search_bar.dart';
import '../../../widget/bottomNavBarProf.dart';
import '../../../widget/navbar.dart';

class ClassroomTeacherPage extends StatefulWidget {
  const ClassroomTeacherPage({super.key});

  @override
  State<ClassroomTeacherPage> createState() => _ClassroomTeacherPageState();
}

class _ClassroomTeacherPageState extends State<ClassroomTeacherPage> {
  String _selectedArea = 'Via Acton'; // Imposta un'area predefinita
  List<AllTodayRooms>? _allRooms;
  List<AllTodayRooms>? _filteredRooms;
  bool _isLoading = true;
  bool _isFilterSelected = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    try {
      final rooms = await StudentUtils.allRooms(context);
      setState(() {
        _allRooms = rooms;
        _filteredRooms = rooms;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      // Gestisci l'errore qui, ad esempio mostrando un messaggio all'utente
    }
  }

  void _onAreaChanged(String? newValue) {
    setState(() {
      _selectedArea = newValue!;
      _isFilterSelected = true;
      _filterRooms();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterRooms();
    });
  }

  void _filterRooms() {
    if (_allRooms == null) return;

    setState(() {
      _filteredRooms = _allRooms!.where((room) {
        final areaMatch = room.area == _selectedArea ||
            _selectedArea == '...seleziona Ateneo...';
        final searchMatch = room.services!.any((service) {
          final fields = [
            service.idCorso,
            service.start,
            service.end,
            service.courseName,
            service.prof
          ];
          return fields.any((field) =>
              field != null &&
              field
                  .toString()
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()));
        });
        return areaMatch && searchMatch;
      }).toList();
    });
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
              SearchBarCustom(onChanged: _onSearchChanged),
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
}
