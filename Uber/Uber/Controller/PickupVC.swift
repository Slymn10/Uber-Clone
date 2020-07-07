import MapKit
import UIKit

protocol PickupControllerDelegate:class {
    func didAcceptTrip(_ trip:Trip)
}

class PickupVC: UIViewController {

   //MARK: - Properties
   private let cancelButton: UIButton = {
      let button = UIButton(type: .system)
      button.setImage(#imageLiteral(resourceName: "baseline_clear_white_36pt_2x").withRenderingMode(.alwaysOriginal), for: .normal)
      button.addTarget(self, action: #selector(calcelButtonPressed), for: .touchUpInside)
      return button
   }()
    private let pickupLabel : UILabel = {
        let label = UILabel()
        label.text = "Would you like to pickup this passenger ?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let acceptTripButton : UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(acceptButtonPressed), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Accept Trip", for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
   private let mapView = MKMapView()
   var trip: Trip

   init(trip: Trip) {
      self.trip = trip
      super.init(nibName: nil, bundle: nil)
   }
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

    weak var delegate : PickupControllerDelegate?
   //MARK: - Lifecycle
   override func viewDidLoad() {
      super.viewDidLoad()
      configureUI()
    configureMapView()
   }

    override var prefersStatusBarHidden: Bool{
        return true
    }
   //MARK: - Selectors

   @objc func calcelButtonPressed() {
      dismiss(animated: true, completion: nil)
   }
    @objc func acceptButtonPressed(){
        Service.shared.acceptTrip(trip: trip) { (error, ref) in
            self.delegate?.didAcceptTrip(self.trip)
        }
    }

   //MARK: - API


   //MARK: - Helper Functions
   func configureUI() {
      view.backgroundColor = .backgroundColor
      view.addSubview(cancelButton)
      cancelButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingLeft: 16)

      view.addSubview(mapView)
      mapView.setDimensions(height: 270, width: 270)
      mapView.layer.cornerRadius = 135
      mapView.centerX(inView: view)
      mapView.centerY(inView: view, constant: -200)

    view.addSubview(pickupLabel)
    pickupLabel.centerX(inView: view)
    pickupLabel.anchor(top: mapView.bottomAnchor,paddingTop: 16)

    view.addSubview(acceptTripButton)
    acceptTripButton.anchor(top: pickupLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32,paddingRight: 32,height: 50)
   }
    func configureMapView(){
        let region = MKCoordinateRegion(center: trip.pickupCoordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: false)
        //let placemark = MKPlacemark(coordinate: trip.pickupCoordinates)
        let anno = MKPointAnnotation()
        anno.coordinate = trip.pickupCoordinates
        mapView.addAnnotation(anno)
        mapView.selectAnnotation(anno, animated: true)
    }


}
