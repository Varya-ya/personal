import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-vehicle',
  templateUrl: './vehicle.component.html',
  styleUrls: ['./vehicle.component.css']
})
export class VehicleComponent implements OnInit {
  vehicleCreationStatus = 'No vehicle was created!';
  vehicleType = '';

  constructor() {
    
  }

  ngOnInit(): void {
  }

  onCreateVehicle() {
    this.vehicleCreationStatus = 'Vehicle #1. Vehicle Type is ' + this.vehicleType;
  }

  onVehicleType(event: Event) {
    this.vehicleType = (<HTMLInputElement>event.target).value;
  }
}
