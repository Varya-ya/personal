import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-vehicle',
  templateUrl: './vehicle.component.html',
  styleUrls: ['./vehicle.component.css']
})
export class VehicleComponent implements OnInit {
  vehicleCreationStatus = 'No vehicle was created!';

  constructor() {
    
  }

  ngOnInit(): void {
  }

  onCreateVehicle() {
    this.vehicleCreationStatus = 'Vehicle was created!'
  }
}
