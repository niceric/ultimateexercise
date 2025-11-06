import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/models/local_exercise.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:trainingapp/services/exercise_service.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/theme/app_theme.dart';

class ModernExerciseSelection extends StatefulWidget {
  final Workout workout;

  const ModernExerciseSelection({Key? key, required this.workout})
      : super(key: key);

  @override
  State<ModernExerciseSelection> createState() =>
      _ModernExerciseSelectionState();
}

class _ModernExerciseSelectionState extends State<ModernExerciseSelection> {
  final TextEditingController _searchController = TextEditingController();
  final ExerciseService _exerciseService = ExerciseService();
  List<LocalExercise> _searchResults = [];
  String _selectedMuscleGroup = 'All';
  bool _isLoading = false;

  final List<String> _muscleGroups = [
    'All',
    'Chest',
    'Back',
    'Legs',
    'Shoulders',
    'Biceps',
    'Triceps',
    'Abs',
    'Cardio',
  ];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    setState(() => _isLoading = true);
    final results = await _exerciseService.searchExercises('');
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  Future<void> _searchExercises(String query) async {
    setState(() => _isLoading = true);
    final results = await _exerciseService.searchExercises(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  List<LocalExercise> get _filteredExercises {
    if (_selectedMuscleGroup == 'All') {
      return _searchResults;
    }
    return _searchResults
        .where((e) => e.muscleGroup == _selectedMuscleGroup)
        .toList();
  }

  void _addExercise(LocalExercise exercise) {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    provider.addExercise(
      Exercise(exerciseName: exercise.name, exerciseSets: []),
      widget.workout.id,
    );
    Navigator.pop(context);
  }

  void _showCreateCustomExercise() {
    final nameController = TextEditingController();
    String selectedGroup = 'Chest';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppTheme.cardDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Create Custom Exercise',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Exercise Name',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppTheme.accentPurple),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: AppTheme.accentCyan, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.accentPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: selectedGroup,
                  isExpanded: true,
                  underline: SizedBox(),
                  dropdownColor: AppTheme.cardDark,
                  style: TextStyle(color: Colors.white),
                  items: _muscleGroups
                      .where((g) => g != 'All')
                      .map((group) => DropdownMenuItem(
                            value: group,
                            child: Text(group),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedGroup = value!;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white.withOpacity(0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  await _exerciseService.addCustomExercise(
                    nameController.text,
                    selectedGroup,
                  );
                  Navigator.pop(context);
                  _searchExercises(nameController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Column(
            children: [
              // Header
              FadeInAnimation(
                delay: Duration(milliseconds: 100),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.cardDark,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Exercise',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Choose from ${_searchResults.length}+ exercises',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: _showCreateCustomExercise,
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: AppTheme.purpleGradient,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentPurple.withOpacity(0.3),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              FadeInAnimation(
                delay: Duration(milliseconds: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search exercises...',
                        hintStyle:
                            TextStyle(color: Colors.white.withOpacity(0.5)),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search_rounded,
                          color: AppTheme.accentCyan,
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear_rounded,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _searchExercises('');
                                },
                              )
                            : null,
                      ),
                      onChanged: _searchExercises,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Muscle Group Filter
              FadeInAnimation(
                delay: Duration(milliseconds: 300),
                child: Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _muscleGroups.length,
                    itemBuilder: (context, index) {
                      final group = _muscleGroups[index];
                      final isSelected = _selectedMuscleGroup == group;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMuscleGroup = group;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? AppTheme.purpleGradient
                                  : null,
                              color: isSelected ? null : AppTheme.cardDark,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppTheme.accentPurple
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Text(
                              group,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Exercise List
              Expanded(
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(AppTheme.accentCyan),
                        ),
                      )
                    : _filteredExercises.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.3),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No exercises found',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            itemCount: _filteredExercises.length,
                            itemBuilder: (context, index) {
                              final exercise = _filteredExercises[index];
                              return FadeInAnimation(
                                delay: Duration(
                                    milliseconds: 400 + (index * 50)),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 12.0),
                                  child: GestureDetector(
                                    onTap: () => _addExercise(exercise),
                                    child: GradientCard(
                                      gradient: LinearGradient(
                                        colors: [
                                          AppTheme.cardDark,
                                          AppTheme.cardDark.withOpacity(0.8),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient:
                                                  AppTheme.purpleGradient,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              _getMuscleGroupIcon(
                                                  exercise.muscleGroup),
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  exercise.name,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: AppTheme
                                                            .accentCyan
                                                            .withOpacity(0.2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Text(
                                                        exercise.muscleGroup,
                                                        style: TextStyle(
                                                          color: AppTheme
                                                              .accentCyan,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ),
                                                    if (exercise.isCustom) ...[
                                                      SizedBox(width: 8),
                                                      Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 8,
                                                          vertical: 4,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: AppTheme
                                                              .accentGreen
                                                              .withOpacity(0.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: Text(
                                                          'Custom',
                                                          style: TextStyle(
                                                            color: AppTheme
                                                                .accentGreen,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.add_circle_rounded,
                                            color: AppTheme.accentCyan,
                                            size: 28,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getMuscleGroupIcon(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return Icons.fitness_center_rounded;
      case 'Back':
        return Icons.accessibility_new_rounded;
      case 'Legs':
        return Icons.directions_run_rounded;
      case 'Shoulders':
        return Icons.accessibility_rounded;
      case 'Biceps':
      case 'Triceps':
        return Icons.sports_martial_arts_rounded;
      case 'Abs':
        return Icons.format_align_center_rounded;
      case 'Cardio':
        return Icons.favorite_rounded;
      default:
        return Icons.fitness_center_rounded;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
