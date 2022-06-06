import { Component, OnInit } from '@angular/core';

import { Recipe } from '../recipe.model';

@Component({
  selector: 'app-recipe-list',
  templateUrl: './recipe-list.component.html',
  styleUrls: ['./recipe-list.component.css']
})
export class RecipeListComponent implements OnInit {
  recipes: Recipe[] = [
    new Recipe('Test', 'Test', 'https://www.paperchaseblog.com/wp-content/uploads/2015/08/RECIPE-BOOK-INSIDE.jpg')  ];

  constructor() { }

  ngOnInit(): void {
  }

}
