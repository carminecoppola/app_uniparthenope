import 'package:appuniparthenope/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../widget/CustomLoadingIndicator.dart';
import '../../widget/ServicesWidget/RoomWidget/areaDropdown.dart';
import '../../widget/ServicesWidget/RoomWidget/roomList.dart';
import '../../widget/bottomNavBar.dart';
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
    final authenticatedUser =
        Provider.of<AuthProvider>(context, listen: false).authenticatedUser;

    return Scaffold(
      appBar: NavbarComponent(
        role: authenticatedUser!.user.grpDes.toString(),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(context).translate('classroom_label'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const Divider(
                color: AppColors.primaryColor,
                thickness: 2.5,
                indent: 70,
                endIndent: 70,
              ),
              const SizedBox(height: 20),
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
                    ? CustomLoadingIndicator(
                        text: AppLocalizations.of(context)
                            .translate('loading_classroom'),
                        myColor: AppColors.primaryColor,
                      )
                    : _isFilterSelected
                        ? RoomsList(
                            rooms: _filteredRooms!,
                            selectedArea: _selectedArea,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('select_classroom_label'),
                              style: const TextStyle(
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
      bottomNavigationBar: authenticatedUser.user.grpDes == 'Studenti'
          ? const BottomNavBarComponent()
          : const BottomNavBarProfComponent(),
    );
  }

  void _loadRooms() async {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${AppLocalizations.of(context).translate('error_loading_classrooms')}: $error'),
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
