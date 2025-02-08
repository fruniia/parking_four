import 'package:parking_server/handlers/index.dart';
import 'package:shelf_router/shelf_router.dart';


class ServerSetup {
  ServerSetup._privateConstructor() {
    setUpRoutes();
  }

  static final ServerSetup _instance = ServerSetup._privateConstructor();
  static ServerSetup get instance => _instance;

  //Declaration without initialization
  late Router router;

  Future setUpRoutes() async {
    router = Router();

    //-- Persons --
    router.get('/persons', getPersonsHandler);
    router.get('/persons/<id>', getPersonHandler);
    router.post('/persons', postPersonHandler);
    router.put('/persons/<id>', putPersonHandler);
    router.delete('/persons/<id>', deletePersonHandler);

    //-- Vehicles --
    router.post('/vehicles', postVehicleHandler);
    router.get('/vehicles', getVehiclesHandler);
    router.get('/vehicles/<id>', getVehicleHandler);
    router.put('/vehicles/<id>', putVehicleHandler);
    router.delete('/vehicles/<id>', deleteVehicleHandler);

    //-- ParkingSpaces --
    router.post('/parkingSpaces', postParkingSpaceHandler);
    router.get('/parkingSpaces', getParkingSpacesHandler);
    router.get('/parkingSpaces/<id>', getParkingSpaceHandler);
    router.put('/parkingSpaces/<id>', putParkingSpaceHandler);
    router.delete('/parkingSpaces/<id>', deleteParkingSpaceHandler);

    //-- Parking --
    router.post('/parkings', postParkingHandler);
    router.get('/parkings', getParkingsHandler);
    router.get('/parkings/<id>', getParkingHandler);
    router.put('/parkings/<id>', putParkingHandler);
    router.delete('/parkings/<id>', deleteParkingHandler);
  }
}
