class Vehicle {
  constructor(type, value, vin) {
    this.type = type;
    this.value = value;
    this.vin = vin;
  }
}

class UI {
  addVehicleToList(vehicle) {
    const list = document.getElementById('vehicle-list');
    // Create tr element
    const row = document.createElement('tr');
    // Insert cols
      row.innerHTML = `
      <td>${vehicle.type}</td>
      <td>${vehicle.value}</td>
      <td>${vehicle.vin}</td>
      <td><a href="#" class="delete">X<a></td>
    `;
  
    list.appendChild(row);
  }

  showAlert(message, className) {
    // Create div
    const div = document.createElement('div');
    // Add classes
    div.className = `alert ${className}`;
    // Add text
    div.appendChild(document.createTextNode(message));
    // Get parent
    const container = document.querySelector('.container');
    // Get form
    const form = document.querySelector('#vehicle-form');
    // Insert alert
    container.insertBefore(div, form);

    // Timeout after 3 sec
    setTimeout(function(){
      document.querySelector('.alert').remove();
    }, 3000);
  }

  deleteVehicle(target) {
    if(target.className === 'delete') {
      target.parentElement.parentElement.remove();
    }
  }

  clearFields() {
    document.getElementById('type').value = '';
    document.getElementById('value').value = '';
    document.getElementById('vin').value = '';
  }
}

// Local Storage Class
class Store {
  static getVehicles() {
    let vehicles;
    if(localStorage.getItem('vehicles') === null) {
      vehicles = [];
    } else {
      vehicles = JSON.parse(localStorage.getItem('vehicles'));
    }

    return vehicles;
  }

  static displayVehicles() {
    const vehicles = Store.getVehicles();

    vehicles.forEach(function(vehicle){
      const ui  = new UI;

      // Add vehicle to UI
      ui.addVehicleToList(vehicle);
    });
  }

  static addVehicle(vehicle) {

    const vehicles = Store.getVehicles();

    vehicles.push(vehicle);

    localStorage.setItem('vehicles', JSON.stringify(vehicles));
  }

  static removeVehicle(id) {
    const vehicles = Store.getVehicles();

    vehicles.forEach(function(vehicle, index){
     if(vehicle.id === id) {
      vehicles.splice(index, 1);
     }
    });

    localStorage.setItem('vehicles', JSON.stringify(vehicles));
  }
}

// DOM Load Event
document.addEventListener('DOMContentLoaded', Store.displayVehicles);

// Event Listener for add vehicle
document.getElementById('vehicle-form').addEventListener('submit', function(e){
  // Get form values
  const type = document.getElementById('type').value,
        value = document.getElementById('value').value,
        vin = document.getElementById('vin').value

  // Instantiate vehicle
  const vehicle = new Vehicle(type, value, vin);

  // Instantiate UI
  const ui = new UI();

  console.log(ui);

  // Validate
  if(type === '' || value === '' || vin === '') {
    // Error alert
    ui.showAlert('Please fill in all fields', 'error');
  } else {
    // Add vehicle to list
    ui.addVehicleToList(vehicle);

    // Add to LS
    Store.addVehicle(vehicle);

    // Show success
    ui.showAlert('Vehicle Added!', 'success');
  
    // Clear fields
    ui.clearFields();
  }

  e.preventDefault();
});

// Event Listener for delete
document.getElementById('vehicle-list').addEventListener('click', function(e){

  // Instantiate UI
  const ui = new UI();

  // Delete vehicle
  ui.deleteVehicle(e.target);

  // Remove from LS
  Store.removeVehicle(e.target.parentElement.previousElementSibling.textContent);

  // Show message
  ui.showAlert('Vehicle Removed!', 'success');

  e.preventDefault();
});