import 'package:flutter/material.dart';
import 'package:appuniparthenope/model/teacherService/room_data.dart';
import '../../../main.dart';
import '../../../utilityFunctions/studentUtilsFunction.dart';
import '../../../widget/CustomLoadingIndicator.dart';
import '../../../widget/ServicesWidget/RoomWidget/areaDropdown.dart';
import '../../../widget/ServicesWidget/RoomWidget/roomList.dart';
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
  bool _isLoading = true;
  bool _isFilterSelected = false;

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
              Expanded(
                child: _isLoading
                    ? const CustomLoadingIndicator(
                        text: 'Caricamento informazioni aule',
                        myColor: AppColors.primaryColor,
                      )
                    : _isFilterSelected
                        ? RoomsList(
                            rooms: _allRooms!,
                            selectedArea: _selectedArea,
                          )
                        : const Text(
                            'Seleziona un\'area per visualizzare le aule',
                            style: TextStyle(
                                color: AppColors.primaryColor, fontSize: 20),
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
