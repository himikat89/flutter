/*
 * This file is part of wger Workout Manager <https://github.com/wger-project>.
 * Copyright (C) 2020, 2021 wger Team
 *
 * wger Workout Manager is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:wger/helpers/json.dart';
import 'package:wger/models/nutrition/ingredient.dart';
import 'package:wger/models/nutrition/ingredient_weight_unit.dart';

import 'nutritrional_values.dart';

part 'meal_item.g.dart';

@JsonSerializable()
class MealItem {
  @JsonKey(required: true)
  int? id;

  @JsonKey(required: false, name: 'meal')
  late int mealId;

  @JsonKey(required: false, name: 'ingredient')
  late int ingredientId;

  @JsonKey(ignore: true)
  late Ingredient ingredientObj;

  @JsonKey(required: false, name: 'weight_unit')
  int? weightUnitId;

  @JsonKey(ignore: true)
  IngredientWeightUnit? weightUnitObj;

  @JsonKey(required: true, fromJson: stringToNum, toJson: numToString)
  late num amount;

  MealItem({
    this.id,
    int? mealId,
    required this.ingredientId,
    this.weightUnitId,
    required this.amount,
  }) {
    if (mealId != null) {
      this.mealId = mealId;
    }
  }

  MealItem.empty();

  // Boilerplate
  factory MealItem.fromJson(Map<String, dynamic> json) => _$MealItemFromJson(json);

  Map<String, dynamic> toJson() => _$MealItemToJson(this);

  /// Calculations
  NutritionalValues get nutritionalValues {
    // This is already done on the server. It might be better to read it from there.
    final out = NutritionalValues();

    //final weight = this.weightUnit == null ? amount : amount * weightUnit.amount * weightUnit.grams;
    final weight = amount;

    out.energy = ingredientObj.energy * weight / 100;
    out.protein = ingredientObj.protein * weight / 100;
    out.carbohydrates = ingredientObj.carbohydrates * weight / 100;
    out.carbohydratesSugar = ingredientObj.carbohydratesSugar * weight / 100;
    out.fat = ingredientObj.fat * weight / 100;
    out.fatSaturated = ingredientObj.fatSaturated * weight / 100;
    out.fibres = ingredientObj.fibres * weight / 100;
    out.sodium = ingredientObj.sodium * weight / 100;

    return out;
  }
}
