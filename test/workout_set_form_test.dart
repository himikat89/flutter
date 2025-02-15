/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * wger Workout Manager is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:wger/helpers/consts.dart';
import 'package:wger/models/workouts/day.dart';
import 'package:wger/models/workouts/set.dart';
import 'package:wger/models/workouts/setting.dart';
import 'package:wger/models/workouts/workout_plan.dart';
import 'package:wger/providers/exercises.dart';
import 'package:wger/providers/workout_plans.dart';
import 'package:wger/widgets/workouts/forms.dart';

import '../test_data/workouts.dart';
import 'base_provider_test.mocks.dart';
import 'utils.dart';
import 'workout_form_test.mocks.dart';
import 'workout_set_form_test.mocks.dart';

@GenerateMocks([ExercisesProvider])
void main() {
  var mockWorkoutPlans = MockWorkoutPlansProvider();
  final MockExercisesProvider mockExercises = MockExercisesProvider();
  final WorkoutPlan workoutPlan = getWorkout();
  final client = MockClient();
  Day day = Day();

  setUp(() {
    final WorkoutPlan workoutPlan = getWorkout();
    day = workoutPlan.days.first;
    mockWorkoutPlans = MockWorkoutPlansProvider();
  });

  Widget createHomeScreen({locale = 'en'}) {
    return ChangeNotifierProvider<WorkoutPlansProvider>(
      create: (context) => WorkoutPlansProvider(
        testAuthProvider,
        mockExercises,
        [workoutPlan],
        client,
      ),
      child: ChangeNotifierProvider(
          create: (context) => testExercisesProvider,
          child: MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            navigatorKey: GlobalKey<NavigatorState>(),
            home: Scaffold(
              body: SetFormWidget(day),
            ),
          )),
    );
  }

  testWidgets('Test the widgets on the SetFormWidget', (WidgetTester tester) async {
    await tester.pumpWidget(createHomeScreen());
    await tester.pumpAndSettle();

    expect(find.byType(TypeAheadFormField), findsOneWidget);
    expect(find.byType(Slider), findsOneWidget);
    //expect(find.byType(SwitchListTile), findsOneWidget);
    expect(find.byKey(Key(SUBMIT_BUTTON_KEY_NAME)), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Test creating a new set', (WidgetTester tester) async {
    when(mockWorkoutPlans.addSet(any)).thenAnswer((_) => Future.value(Set.empty()));
    when(mockWorkoutPlans.addSetting(any)).thenAnswer((_) => Future.value(Setting.empty()));
    when(mockWorkoutPlans.fetchSmartText(any, any)).thenAnswer((_) => Future.value('2 x 10'));

    await tester.pumpWidget(createHomeScreen());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(Key('field-typeahead')), 'exercise');
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(Key(SUBMIT_BUTTON_KEY_NAME)));

    //verify(mockWorkoutPlans.addSet(any));
    //verify(mockWorkoutPlans.addSettinbg(any));
    //verify(mockWorkoutPlans.fetchSmartText(any, any));
  });
}
